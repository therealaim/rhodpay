# RHODPAY Flutter Starter

This is Stage 1 of the RHODPAY prototype: a branded Flutter shell, dashboard concept,
and searchable alphabetical country-wallet directory.

## Important
- All balances and interactions are sample/demo data.
- No real money movement, bank connection, card issuance, or payment processing exists.
- The country directory is generated from ISO country records and Babel territory-currency
  data. It is a starting reference dataset, not a legally or commercially verified list
  of supported wallet products. Review currency mappings before treating them as final.
- Some countries use multiple currencies, and some currencies are shared by multiple
  countries. A country entry does not mean a real wallet can be opened there.

## Run
Install Flutter SDK, then from this directory:
```bash
flutter pub get
flutter run
```

## Stage plan
1. Brand system, navigation, dashboard, country-wallet directory (starter).
2. Demo registration/login and profile.
3. Simulated send/receive transfers and transaction ledger.
4. Currency exchange calculator with clearly labelled sample rates.
5. Card mockups and invoice creation.
6. Tests, accessibility, privacy disclosures, and store-readiness review.

## Before public release
Use original RHODPAY artwork and copy, check name/trademark availability, and clearly
disclose simulated functionality. Do not collect real financial credentials or imply
that balances/cards are real. Real financial services require appropriate licensed
partners, legal review, security controls, and regulatory compliance.
