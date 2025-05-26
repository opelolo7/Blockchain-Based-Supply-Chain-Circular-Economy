# Blockchain-Based Supply Chain Circular Economy

A comprehensive blockchain solution built with Clarity smart contracts for tracking and managing circular economy principles in supply chains. This system enables complete product lifecycle management from manufacturing to end-of-life processing.

## 🌟 Features

### Core Contracts

1. **Product Verification Contract** (`product-verification.clar`)
    - Validates items in circulation
    - Tracks product authenticity and ownership
    - Manages product status throughout lifecycle
    - Authorized verifier system

2. **Material Passport Contract** (`material-passport.clar`)
    - Records component composition
    - Tracks material types and percentages
    - Manages recyclability information
    - Source tracking for materials

3. **Usage Tracking Contract** (`usage-tracking.clar`)
    - Monitors product lifecycle events
    - Records usage patterns and maintenance
    - Tracks efficiency ratings
    - Event-based usage logging

4. **End-of-Life Management Contract** (`end-of-life-management.clar`)
    - Handles product disposal processes
    - Manages recycling facilities
    - Tracks disposal methods and certifications
    - Environmental impact recording

5. **Value Recovery Contract** (`value-recovery.clar`)
    - Tracks economic benefits of circularity
    - Records material and energy recovery values
    - Manages circular economy metrics
    - Transaction tracking for recovered value

## 🚀 Getting Started

### Prerequisites

- Clarity CLI or Clarinet for contract deployment
- Stacks blockchain testnet/mainnet access
- Basic understanding of Clarity smart contracts

### Contract Deployment

1. Deploy contracts in the following order:
   ```bash
   clarinet deploy product-verification
   clarinet deploy material-passport
   clarinet deploy usage-tracking
   clarinet deploy end-of-life-management
   clarinet deploy value-recovery
   ```

2. Initialize contract owners and authorized users:
   ```clarity
   ;; Add authorized verifiers
   (contract-call? .product-verification add-verifier 'SP1234...)
   
   ;; Add material passport creators
   (contract-call? .material-passport add-creator 'SP1234...)
   
   ;; Add usage trackers
   (contract-call? .usage-tracking add-tracker 'SP1234...)
   ```

## 📋 Usage Examples

### Creating a Product

```clarity
;; 1. Create product verification record
(contract-call? .product-verification create-product "PROD-001" 'SP1234...)

;; 2. Create material passport
(contract-call? .material-passport create-passport 
  "PROD-001" 
  u1000    ;; total weight in grams
  u80      ;; 80% recyclable
  u20      ;; 20% biodegradable
  false)   ;; no hazardous materials

;; 3. Add material components
(contract-call? .material-passport add-component
  "PROD-001"
  "COMP-001"
  "aluminum"
  u600     ;; 600g
  u60      ;; 60% of total
  true     ;; recyclable
  "supplier-a")

;; 4. Initialize usage tracking
(contract-call? .usage-tracking initialize-tracking "PROD-001" 'SP1234...)
```

### Tracking Product Usage

```clarity
;; Record normal usage
(contract-call? .usage-tracking record-usage-event
  "PROD-001"
  u1       ;; USAGE_TYPE_NORMAL
  u24      ;; 24 hours
  "Daily operation")

;; Record maintenance
(contract-call? .usage-tracking record-usage-event
  "PROD-001"
  u3       ;; USAGE_TYPE_MAINTENANCE
  u2       ;; 2 hours
  "Routine maintenance check")
```

### End-of-Life Processing

```clarity
;; Process end-of-life
(contract-call? .end-of-life-management process-end-of-life
  "PROD-001"
  u1       ;; DISPOSAL_RECYCLE
  u500     ;; recovery value
  u10      ;; environmental impact score
  "CERT-123"
  "Recycled at certified facility")

;; Record value recovery
(contract-call? .value-recovery record-value-recovery
  "PROD-001"
  u300     ;; material value
  u100     ;; energy value
  u50      ;; component value
  u50      ;; refurbishment value
  u200     ;; environmental savings
  u15)     ;; carbon offset
```

## 🔧 Contract Functions

### Product Verification
- `create-product`: Register new product
- `update-product-status`: Update product lifecycle status
- `verify-product`: Mark product as verified
- `get-product`: Retrieve product information

### Material Passport
- `create-passport`: Create material composition record
- `add-component`: Add material component details
- `get-passport`: Retrieve material passport
- `get-component`: Get component information

### Usage Tracking
- `initialize-tracking`: Start usage monitoring
- `record-usage-event`: Log usage events
- `get-usage-record`: Retrieve usage statistics
- `get-usage-event`: Get specific usage event

### End-of-Life Management
- `register-facility`: Register recycling facility
- `certify-facility`: Certify recycling facility
- `process-end-of-life`: Record disposal process
- `get-eol-record`: Retrieve disposal information

### Value Recovery
- `record-value-recovery`: Log recovered values
- `record-recovery-transaction`: Track value transactions
- `update-ce-metrics`: Update circular economy metrics
- `get-value-recovery`: Retrieve recovery information

## 🔐 Security Features

- **Authorization System**: Role-based access control for all operations
- **Data Integrity**: Immutable records on blockchain
- **Verification**: Multi-step verification process for authenticity
- **Audit Trail**: Complete transaction history for all operations

## 🌱 Circular Economy Benefits

- **Transparency**: Full visibility into product lifecycle
- **Traceability**: Track materials from source to disposal
- **Value Recovery**: Quantify economic benefits of circular practices
- **Environmental Impact**: Monitor and reduce environmental footprint
- **Compliance**: Automated compliance with circular economy regulations

## 📊 Metrics and Reporting

The system tracks key circular economy indicators:
- Total products processed
- Value recovered from end-of-life processing
- Carbon offset achieved
- Waste diverted from landfills
- Material recovery rates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For questions and support:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki
