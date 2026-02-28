# Development Setup Guide

## Prerequisites

- Node.js 18+ 
- npm or yarn
- Git

## Initial Setup

### 1. Clone the repository

```bash
git clone https://github.com/huminghua0901/clawtest.git
cd clawtest
```

### 2. Install dependencies

```bash
# Frontend
cd frontend
npm install

# Backend
cd ../backend
npm install
```

### 3. Environment variables

```bash
# Frontend
cd frontend
cp .env.example .env
# Edit .env with your settings

# Backend
cd ../backend
cp .env.example .env
# Edit .env with your settings
```

### 4. Database setup

```bash
cd backend
npm run prisma:generate
npm run prisma:migrate
```

## Development

### Start Frontend

```bash
cd frontend
npm run dev
```

Visit http://localhost:3000

### Start Backend

```bash
cd backend
npm run dev
```

Visit http://localhost:3001

### Code Quality

```bash
# Frontend
cd frontend
npm run lint          # Check code
npm run lint:fix      # Fix linting issues
npm run format        # Format code
npm run format:check  # Check formatting

# Backend
cd backend
npm run lint
npm run lint:fix
npm run format
npm run format:check
```

## Database

### Prisma Studio (GUI)

```bash
cd backend
npm run prisma:studio
```

### Create Migration

```bash
cd backend
npx prisma migrate dev --name migration_name
```

### Reset Database

```bash
cd backend
npx prisma migrate reset
```

## Project Structure

```
clawtest/
├── frontend/              # Next.js frontend
│   ├── src/
│   │   ├── app/          # App router pages
│   │   └── components/   # React components
│   └── public/           # Static assets
├── backend/              # Express backend
│   ├── src/
│   │   ├── prisma.ts     # Prisma client
│   │   └── index.ts      # Main server
│   └── prisma/           # Database schema and migrations
└── README.md
```

## Default Credentials

Admin account (created by seed script):
- Email: admin@blog.local
- Password: admin123

⚠️ **Important:** Change these credentials in production!

## Troubleshooting

### Port already in use

Change port in `.env`:
- Frontend: NEXT_PUBLIC_API_URL
- Backend: PORT

### Database errors

```bash
cd backend
npm run prisma:generate
npm run prisma:migrate
```

### TypeScript errors

```bash
cd frontend
npm run build

cd ../backend
npm run build
```
