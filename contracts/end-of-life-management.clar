;; End-of-Life Management Contract
;; Handles product disposal and recycling processes

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_EOL_NOT_FOUND (err u401))
(define-constant ERR_EOL_ALREADY_EXISTS (err u402))
(define-constant ERR_INVALID_DISPOSAL_METHOD (err u403))

;; Disposal methods
(define-constant DISPOSAL_RECYCLE u1)
(define-constant DISPOSAL_REFURBISH u2)
(define-constant DISPOSAL_LANDFILL u3)
(define-constant DISPOSAL_INCINERATE u4)
(define-constant DISPOSAL_DONATE u5)

;; End-of-life records
(define-map eol-records
  { product-id: (string-ascii 64) }
  {
    disposal-method: uint,
    processor: principal,
    disposal-date: uint,
    recovery-value: uint,
    environmental-impact: uint,
    certification: (string-ascii 64),
    notes: (string-ascii 256)
  }
)

;; Recycling facilities
(define-map recycling-facilities
  { facility-id: (string-ascii 32) }
  {
    operator: principal,
    location: (string-ascii 64),
    certified: bool,
    specialization: (string-ascii 64),
    capacity: uint
  }
)

;; Authorized processors
(define-map authorized-processors principal bool)

;; Initialize contract owner as authorized processor
(map-set authorized-processors CONTRACT_OWNER true)

;; Add authorized processor
(define-public (add-processor (processor principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (ok (map-set authorized-processors processor true))
  )
)

;; Register recycling facility
(define-public (register-facility
  (facility-id (string-ascii 32))
  (location (string-ascii 64))
  (specialization (string-ascii 64))
  (capacity uint))
  (begin
    (asserts! (default-to false (map-get? authorized-processors tx-sender)) ERR_UNAUTHORIZED)
    (ok (map-set recycling-facilities
      { facility-id: facility-id }
      {
        operator: tx-sender,
        location: location,
        certified: false,
        specialization: specialization,
        capacity: capacity
      }
    ))
  )
)

;; Certify recycling facility
(define-public (certify-facility (facility-id (string-ascii 32)))
  (let ((facility (map-get? recycling-facilities { facility-id: facility-id })))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match facility
      existing-facility
      (ok (map-set recycling-facilities
        { facility-id: facility-id }
        (merge existing-facility { certified: true })
      ))
      (err u404)
    )
  )
)

;; Process end-of-life
(define-public (process-end-of-life
  (product-id (string-ascii 64))
  (disposal-method uint)
  (recovery-value uint)
  (environmental-impact uint)
  (certification (string-ascii 64))
  (notes (string-ascii 256)))
  (let ((existing-record (map-get? eol-records { product-id: product-id })))
    (asserts! (default-to false (map-get? authorized-processors tx-sender)) ERR_UNAUTHORIZED)
    (asserts! (is-none existing-record) ERR_EOL_ALREADY_EXISTS)
    (asserts! (and (>= disposal-method DISPOSAL_RECYCLE) (<= disposal-method DISPOSAL_DONATE)) ERR_INVALID_DISPOSAL_METHOD)
    (ok (map-set eol-records
      { product-id: product-id }
      {
        disposal-method: disposal-method,
        processor: tx-sender,
        disposal-date: block-height,
        recovery-value: recovery-value,
        environmental-impact: environmental-impact,
        certification: certification,
        notes: notes
      }
    ))
  )
)

;; Get end-of-life record
(define-read-only (get-eol-record (product-id (string-ascii 64)))
  (map-get? eol-records { product-id: product-id })
)

;; Get recycling facility
(define-read-only (get-facility (facility-id (string-ascii 32)))
  (map-get? recycling-facilities { facility-id: facility-id })
)

;; Check if processor is authorized
(define-read-only (is-authorized-processor (processor principal))
  (default-to false (map-get? authorized-processors processor))
)
