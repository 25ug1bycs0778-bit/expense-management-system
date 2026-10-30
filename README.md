# Orbit — Expense Management System

A full-stack money dashboard with an HTML/CSS/JavaScript frontend, a Flask REST API, and local SQLite storage. Track income and expenses, see month-by-month charts, search and filter transactions, and set spending plans by category.

## Run locally on Windows

Double-click `run.bat`, or open a PowerShell terminal in this folder:

```powershell
.\run.bat
```

The launcher creates `backend\.venv`, installs the requirements, creates the SQLite database automatically, and opens the site at <http://127.0.0.1:5001>. Keep the terminal open while using the app; press Ctrl+C to stop it. Do not open `frontend\index.html` directly; run Flask so the frontend and API are connected.

You can also start the API manually:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

The local database is `backend\expenses.db`. Set `EXPENSE_DB_PATH` before starting Flask to use a different local file.

## Dashboard

- Add, edit, search, filter, and delete income and expense transactions.
- Review current-month income, expenses, remaining balance, and activity.
- Compare income and expenses over the previous six months.
- Set, edit, and remove monthly spending budgets for each category.
- Amounts are entered and displayed in Indian rupees (INR). Money is stored in integer paise to avoid rounding errors.

Available categories: Food & Dining, Transport, Shopping, Bills & Utilities, Entertainment, Healthcare, Education, Travel, and Other. Transactions can have an amount up to ₹999,999,999.99 with at most two decimal places.

## REST API

All JSON responses use INR amounts as decimal rupees. Dates use `YYYY-MM-DD`; months use `YYYY-MM`. Invalid input returns a JSON `error` and `400 Bad Request`. Supported transaction categories and types are validated by the API.

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `GET` | `/api/health` | Check API availability |
| `GET` | `/api/summary?month=YYYY-MM` | Monthly totals, category breakdown, budget amounts, and six-month chart data |
| `GET` | `/api/transactions?month=YYYY-MM` | List a month's transactions |
| `GET` | `/api/transactions?month=YYYY-MM&type=expense&category=Food%20%26%20Dining&search=coffee` | Filter and search a month's transactions |
| `POST` | `/api/transactions` | Create an income or expense |
| `PUT` / `PATCH` | `/api/transactions/<id>` | Replace or update a transaction |
| `DELETE` | `/api/transactions/<id>` | Delete a transaction |
| `GET` | `/api/budgets` | List monthly category budgets |
| `PUT` | `/api/budgets/<category>` | Create or update a monthly budget |
| `DELETE` | `/api/budgets/<category>` | Remove a monthly budget |

Example expense request:

```json
{
  "description": "Coffee with a friend",
  "amount": 8.5,
  "category": "Food & Dining",
  "type": "expense",
  "date": "2026-10-30",
  "note": "A little afternoon treat"
}
```

## Test with Postman

Import `postman/Expense-Management-System.postman_collection.json`. Its default `baseUrl` is `http://127.0.0.1:5001`. Run **Create expense** before update or delete; its Postman test automatically saves the returned transaction ID.

## Run automated tests

From `backend`:

```powershell
python -m unittest discover -s tests -v
```

## Deploy to Vercel

Local development uses SQLite. Vercel's serverless filesystem is temporary, so the deployed API uses PostgreSQL. Before deployment, create a hosted PostgreSQL database and configure `DATABASE_URL` as a Vercel Environment Variable. Never commit or share the connection URL.

The root `app.py` exposes the Flask application to Vercel. `build.py` publishes `frontend/` through Vercel's static CDN; `/api/*` requests run in the Flask Python function. The Vercel build configuration is in `pyproject.toml`, `vercel.json`, and `.python-version`. If no persistent database is configured, Vercel serves the dashboard but the API responds with `503 Service Unavailable` instead of silently losing data.
