---
description: /show-me-your-work starts a decision log with the documented TSV header.
tags: [trail]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

/show-me-your-work I'm starting a long migration of our billing cron and I'll review it in the morning. Start the trail in decisions.tsv and log the first entry: you read the existing cron config at config/cron.yaml and found it runs hourly, so the migration has to keep the hourly cadence.
