# AssetHub — IT Asset Management

A Flask web app for tracking IT assets (laptops, servers, monitors, licenses, etc.) with a visual dashboard.

## Features

- **Dashboard** with KPI cards (total assets, in use, in repair, total value), a category bar chart, a status doughnut chart, warranty-expiring alerts, and recently-added assets.
- **Asset inventory** with search and filters (by category / status).
- **Full CRUD**: add, edit, and delete assets.
- Tracks tag, name, category, status, manufacturer, model, serial number, assigned person, location, purchase date/cost, warranty end, and notes.
- **SQLite** storage — no external database needed. Seeds 12 demo assets on first run.

## Run

```bash
pip install -r requirements.txt
python app.py
```

Then open **http://localhost:7077**

The database file `assets.db` is created automatically next to `app.py`.

## Structure

```
app.py                # Flask app, routes, SQLite models, seed data
requirements.txt
static/style.css      # styling
templates/
  base.html           # layout + sidebar
  dashboard.html      # dashboard with Chart.js charts
  assets.html         # inventory list + filters
  asset_form.html     # add / edit form
```
