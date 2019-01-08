---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
tags: []
slug: {{ now.Unix}}
keywords: [{{ replace .TranslationBaseName "-" " " | title }}]
date: {{now.Format "2006-01-02 15:04:05"}}
draft: true
---
