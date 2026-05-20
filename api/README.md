<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>
    <p align="center">
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>
<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>
<a href="https://coveralls.io/github/nestjs/nest?branch=master" target="_blank"><img src="https://coveralls.io/repos/github/nestjs/nest/badge.svg?branch=master#9" alt="Coverage" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>
<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>
<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>
  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg" alt="Donate us"/></a>
    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>
  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow" alt="Follow us on Twitter"></a>
</p>
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

**Afghan Pride (`pride-api`)** — NestJS service for [`plan-04-backend-api.md`](../plan-04-backend-api.md).

**Database:** PostgreSQL via **Prisma** (`prisma/schema.prisma`). Set `DATABASE_URL` in **`api/.env`** (see [`.env.example`](.env.example); never commit `.env`). **Migrations:** from repo root run `npm run db:migrate` (runs Prisma inside `api/` so the schema is found), or `cd api && npx prisma migrate deploy`. Local DB: `docker compose up -d` from repo root, then point `DATABASE_URL` at `postgresql://pride:pride@127.0.0.1:5433/pride_api` (see `docker-compose.yml`). Deploy: same migration command against your hosted `DATABASE_URL` (e.g. Render `preDeployCommand` in [`render.yaml`](../render.yaml)).

**Endpoints (scaffold):**

- `GET /health`
- `GET /license/status` — **Bearer JWT** required; per-shop license row (`trial_active` / `active` / `expired` from `expires_at`).
- `POST /license/redeem` — **Bearer JWT** required; body `{ "code": "..." }`. Redeems a row from **`activation_codes`** when the string matches an active, non-expired code (extends license by `plan_days`). Codes listed in **`PRIDE_LEGACY_REDEEM_CODES`** (default includes `pilot-2026`) still work for dev/e2e without a DB row.
- `POST /auth/login` — body `{ "shop_id"?, "username", "password" }`; returns **JWT** `access_token`, `license_snapshot`, `user` (`plan-04`).
- `POST /shop/create` — body `{ "shop_name", "owner_username", "owner_password" }`; creates **Postgres** shop + owner + trial license; response same as login.
- `POST /shop/join` — same body and response as `POST /auth/login` (shop bootstrap for an existing shop; `plan-04`).
- `GET /shop/users` — **Bearer JWT** required; any shop member may list users (read-only in app for non-owners).
- `POST /shop/users`, `DELETE /shop/users/:userId` — **Bearer JWT** required; **owner only**; trial max **2** users, paid max **5** (`plan-04`).
- `POST /auth/change-password` — **Bearer JWT** required; body `{ "current_password", "new_password" }` for the signed-in user.
- `GET /admin/me` — **Bearer JWT** required; body `{ "is_developer": boolean }` (`plan-18`). Developer access if JWT `sub` is listed in **`PRIDE_DEVELOPER_IDS`** (comma-separated `shop_users.id`) **or** `shop_id|username` matches an entry in **`PRIDE_DEVELOPER_USERS`** (comma-separated).
- `POST /admin/me/password` — **Bearer JWT**; body `{ "current_password", "new_password" }`; **developer only**; changes the signed-in user’s password (username unchanged).
- `GET /admin/stats`, `GET /admin/shops`, `GET /admin/activation-codes`, `POST /admin/activation-codes`, `POST /admin/activation-codes/:id/revoke`, `GET /admin/password-reset-requests`, `POST /admin/password-reset-requests/:id/resolve`, `GET /admin/audit-log` — **developer-only** (`plan-18`); **403** if not developer.
- `POST /sync/push`, `GET /sync/pull?cursor=` — **Bearer JWT** required; JSON contract in [`plan-04-backend-api.md`](../plan-04-backend-api.md). Mutations are persisted in **Postgres** (`shop_sync_mutations`); pull returns appended rows. **403** `{ "error": "license_expired", ... }` when license is expired (`plan-03`).

**JWT:** set `JWT_SECRET` in production (min 32 chars recommended). Default dev secret is embedded for local runs only.

**Dev seed user:** non-production defaults to shop `dev`, username `owner`, password `changeme`. Override with `PRIDE_AUTH_SEED`:
- `shop_id|username|password` **or**
- `shop_id|shop_display_name|username|password`

Optional **`PRIDE_OPERATOR_SEED=shop_id|username|password`**: after the auth seed shop exists, creates a **non-owner** user (idempotent if username already present). Pair with **`PRIDE_DEVELOPER_USERS=shop_id|username`** so that login can use the Developer Portal without looking up `shop_users.id`.

In production, set `PRIDE_AUTH_SEED` explicitly or only `/shop/create` can bootstrap the first shop.

Deploy notes: [`DEPLOY.md`](DEPLOY.md).

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Project setup

```bash
$ npm install
```

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).
