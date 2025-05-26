;; Material Passport Contract
;; Records component composition and material information

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_PASSPORT_NOT_FOUND (err u201))
(define-constant ERR_PASSPORT_ALREADY_EXISTS (err u202))
(define-constant ERR_INVALID_PERCENTAGE (err u203))

;; Material passport structure
(define-map material-passports
  { product-id: (string-ascii 64) }
  {
    creator: principal,
    created-at: uint,
    total-weight: uint,
    recyclable-percentage: uint,
    biodegradable-percentage: uint,
    hazardous-materials: bool
  }
)

;; Material components
(define-map material-components
  { product-id: (string-ascii 64), component-id: (string-ascii 32) }
  {
    material-type: (string-ascii 32),
    weight: uint,
    percentage: uint,
    recyclable: bool,
    source: (string-ascii 64)
  }
)

;; Authorized passport creators
(define-map authorized-creators principal bool)

;; Initialize contract owner as authorized creator
(map-set authorized-creators CONTRACT_OWNER true)

;; Add authorized creator
(define-public (add-creator (creator principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (ok (map-set authorized-creators creator true))
  )
)

;; Create material passport
(define-public (create-passport
  (product-id (string-ascii 64))
  (total-weight uint)
  (recyclable-percentage uint)
  (biodegradable-percentage uint)
  (hazardous-materials bool))
  (let ((existing-passport (map-get? material-passports { product-id: product-id })))
    (asserts! (default-to false (map-get? authorized-creators tx-sender)) ERR_UNAUTHORIZED)
    (asserts! (is-none existing-passport) ERR_PASSPORT_ALREADY_EXISTS)
    (asserts! (<= recyclable-percentage u100) ERR_INVALID_PERCENTAGE)
    (asserts! (<= biodegradable-percentage u100) ERR_INVALID_PERCENTAGE)
    (ok (map-set material-passports
      { product-id: product-id }
      {
        creator: tx-sender,
        created-at: block-height,
        total-weight: total-weight,
        recyclable-percentage: recyclable-percentage,
        biodegradable-percentage: biodegradable-percentage,
        hazardous-materials: hazardous-materials
      }
    ))
  )
)

;; Add material component
(define-public (add-component
  (product-id (string-ascii 64))
  (component-id (string-ascii 32))
  (material-type (string-ascii 32))
  (weight uint)
  (percentage uint)
  (recyclable bool)
  (source (string-ascii 64)))
  (begin
    (asserts! (default-to false (map-get? authorized-creators tx-sender)) ERR_UNAUTHORIZED)
    (asserts! (<= percentage u100) ERR_INVALID_PERCENTAGE)
    (ok (map-set material-components
      { product-id: product-id, component-id: component-id }
      {
        material-type: material-type,
        weight: weight,
        percentage: percentage,
        recyclable: recyclable,
        source: source
      }
    ))
  )
)

;; Get material passport
(define-read-only (get-passport (product-id (string-ascii 64)))
  (map-get? material-passports { product-id: product-id })
)

;; Get material component
(define-read-only (get-component (product-id (string-ascii 64)) (component-id (string-ascii 32)))
  (map-get? material-components { product-id: product-id, component-id: component-id })
)

;; Check if creator is authorized
(define-read-only (is-authorized-creator (creator principal))
  (default-to false (map-get? authorized-creators creator))
)
