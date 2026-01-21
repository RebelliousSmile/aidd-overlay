---
name: wc-to-prestashop
description: Transform WooCommerce product CSV to PrestaShop import format. Use when user needs to "import from WooCommerce", "convert WC products", "migrate products", or "transform CSV for PrestaShop". Handles Divi shortcode cleanup, price conversion (FR to EN format), category mapping, and feature extraction.
allowed-tools: Read, Write, Bash, Glob
---

# WooCommerce to PrestaShop Import Skill

## Overview

This skill transforms a WooCommerce product export CSV into PrestaShop import format:
- Cleans Divi/Elementor shortcodes from descriptions
- Converts French price format (37,9) to PrestaShop format (37.90)
- Extracts attributes as PrestaShop features (Aspect, Couleurs, Dimension)
- Preserves categories as-is
- Prepares image URLs for import

## Input Requirements

**WooCommerce CSV columns used:**
- `ID` → Reference (optional)
- `Nom` → Product name
- `Description courte` → Short description
- `Description` → Full description (requires cleaning)
- `Tarif régulier` → Price
- `Catégories` → Categories (comma-separated)
- `Images` → Image URLs
- `Nom de l'attribut 1/2/3` → Feature names (note: may use typographic apostrophe U+2019)
- `Valeur(s) de l'attribut 1/2/3` → Feature values (note: may use typographic apostrophe U+2019)
- `Publié` → Active status

**Encoding notes:**
- WooCommerce exports use UTF-8 with BOM
- Column names may contain typographic apostrophes (') instead of standard (')
- The script normalizes these characters automatically

## Output Format

**PrestaShop CSV format (products):**
```csv
Product ID;Active (0/1);Name *;Categories (x,y,z...);Price tax excluded;Tax rules ID;Reference #;Summary;Description;Image URLs (x,y,z...);Feature(Name:Value:Position);Quantity;Visibility;Condition;Available for order (0 = No, 1 = Yes);Show price (0 = No, 1 = Yes)
```

**PrestaShop CSV format (categories):**
```csv
Category ID;Active (0/1);Name *;Parent category;Root category (0/1);Description;Meta title;Meta keywords;Meta description;URL rewritten;Image URL
```

## Transformation Rules

### 1. Description Cleaning

Remove Divi Builder shortcodes and HTML artifacts:
```
[et_pb_*] ... [/et_pb_*]  → Remove entirely
[et_pb_*]                 → Remove
@ET-DC@*@                 → Remove
""                        → " (unescape quotes)
\,                        → , (unescape commas)
```

### 2. Price Conversion

```
French: 37,9  → English: 37.90
French: 1 234,56 → English: 1234.56
```

### 3. Category Mapping

Categories are preserved as-is. PrestaShop uses `>` for hierarchy:
```
WC: "60X60, PROMO DALLES - DESTOCKAGE"
PS: "60X60" and "PROMO DALLES - DESTOCKAGE"
```

### 4. Feature Extraction

WooCommerce attributes become PrestaShop features:
```
Attribut 1: Aspect = "Pierre, ardoise, quartzite"
Attribut 2: Couleurs = "Gris moyen - Clair"
Attribut 3: Dimension = "60X60"

→ Feature: Aspect:Pierre, ardoise, quartzite:1|Couleurs:Gris moyen - Clair:2|Dimension:60X60:3
```

### 5. Image URLs

Keep image URLs as-is. PrestaShop import will download them.
Multiple images separated by comma.

## Usage

```bash
# Run transformation
python scripts/transform_wc_to_ps.py input.csv output.csv

# Example with project paths
python scripts/transform_wc_to_ps.py wc-product-export.csv documentation/output/import_products.csv
```

This generates:
- `import_products.csv` - Products file
- `import_categories.csv` - Categories file (auto-generated)
- `import_products_log.txt` - Transformation log

## Workflow

1. **Read** the WooCommerce CSV
2. **Parse** each row
3. **Clean** descriptions (remove Divi shortcodes)
4. **Convert** prices to decimal format
5. **Extract** features from attributes
6. **Format** categories for PrestaShop
7. **Generate** PrestaShop-compatible CSV
8. **Validate** output

## PrestaShop Import Settings

When importing in PrestaShop Admin:
- Separator: `;` (semicolon)
- Multi-value separator: `,` (comma)
- Text qualifier: `"` (double quote)
- Skip first row: Yes (header)
- Force all IDs: No
- Delete all products before import: No (unless fresh start)

## Files Generated

- `import_products.csv` - Main product import file
- `import_categories.csv` - Categories file (auto-extracted)
- `import_products_log.txt` - Transformation log with any warnings

## Error Handling

- Missing required fields: Log warning, skip row
- Invalid price format: Set to 0, log warning
- Empty description: Use short description
- No images: Leave empty (PrestaShop handles)

## Post-Import Steps

1. Create features in PrestaShop Admin first (Catalog > Features):
   - Aspect
   - Couleurs
   - Dimension

2. Import categories first if using separate file

3. Import products

4. Regenerate thumbnails if needed

5. Verify product count matches
