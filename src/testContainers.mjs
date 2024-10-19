#!/usr/bin/env -S node --experimental-specifier-resolution=node
import {
    GenericContainer,
    Wait
  } from 'testcontainers';

const environment = await new GenericContainer('ghcr.io/midnight-ntwrk/proof-server:2.0.6')
.withEnvironment({ RUST_BACKTRACE: 'full' })
.withCommand(['midnight-proof-server --network devnet'])
.withExposedPorts(6300)
.withHealthCheck({
  test: ['CMD', 'curl', '-f', 'http://localhost:6300/version'],
  interval: 30_000,
  timeout: 5000,
  retries: 3,
  startPeriod: 10_000
})
.withWaitStrategy(Wait.forLogMessage('Actix runtime found; starting in Actix runtime'))
.start();

console.log('proof server started')

await new GenericContainer('ghcr.io/midnight-ntwrk/midnight-pubsub-indexer:1.6.0').start()
await new GenericContainer('ghcr.io/midnight-ntwrk/midnight-node:0.2.6-70eb5bf-ariadne').start()
