;; Product Verification Contract
;; Validates items in circulation and tracks their authenticity

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PRODUCT_NOT_FOUND (err u101))
(define-constant ERR_PRODUCT_ALREADY_EXISTS (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Product status types
(define-constant STATUS_MANUFACTURED u1)
(define-constant STATUS_IN_TRANSIT u2)
(define-constant STATUS_DELIVERED u3)
(define-constant STATUS_IN_USE u4)
(define-constant STATUS_END_OF_LIFE u5)

;; Product data structure
(define-map products
  { product-id: (string-ascii 64) }
  {
    manufacturer: principal,
    created-at: uint,
    status: uint,
    current-owner: principal,
    verified: bool
  }
)

;; Authorized verifiers
(define-map authorized-verifiers principal bool)

;; Initialize contract owner as authorized verifier
(map-set authorized-verifiers CONTRACT_OWNER true)

;; Add authorized verifier (only contract owner)
(define-public (add-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (ok (map-set authorized-verifiers verifier true))
  )
)

;; Create new product
(define-public (create-product (product-id (string-ascii 64)) (manufacturer principal))
  (let ((existing-product (map-get? products { product-id: product-id })))
    (asserts! (is-none existing-product) ERR_PRODUCT_ALREADY_EXISTS)
    (ok (map-set products
      { product-id: product-id }
      {
        manufacturer: manufacturer,
        created-at: block-height,
        status: STATUS_MANUFACTURED,
        current-owner: manufacturer,
        verified: true
      }
    ))
  )
)

;; Update product status
(define-public (update-product-status (product-id (string-ascii 64)) (new-status uint) (new-owner principal))
  (let ((product (unwrap! (map-get? products { product-id: product-id }) ERR_PRODUCT_NOT_FOUND)))
    (asserts! (default-to false (map-get? authorized-verifiers tx-sender)) ERR_UNAUTHORIZED)
    (asserts! (and (>= new-status STATUS_MANUFACTURED) (<= new-status STATUS_END_OF_LIFE)) ERR_INVALID_STATUS)
    (ok (map-set products
      { product-id: product-id }
      (merge product { status: new-status, current-owner: new-owner })
    ))
  )
)

;; Verify product authenticity
(define-public (verify-product (product-id (string-ascii 64)))
  (let ((product (unwrap! (map-get? products { product-id: product-id }) ERR_PRODUCT_NOT_FOUND)))
    (asserts! (default-to false (map-get? authorized-verifiers tx-sender)) ERR_UNAUTHORIZED)
    (ok (map-set products
      { product-id: product-id }
      (merge product { verified: true })
    ))
  )
)

;; Get product details
(define-read-only (get-product (product-id (string-ascii 64)))
  (map-get? products { product-id: product-id })
)

;; Check if verifier is authorized
(define-read-only (is-authorized-verifier (verifier principal))
  (default-to false (map-get? authorized-verifiers verifier))
)
