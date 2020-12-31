---
layout: list
title: Posts
description: >
  This is the `list` layout for showing blog posts, which shows just the title and groups them by year of publication.
  Check out the `blog` layout for comparison.
grouped: true
---

{% if page.applause_button %}
  <applause-button
    color={{ site.accent_color | default:'rgb(79,177,186)' }}
    url={{ site.url }}{{ page.url }} >
  </applause-button>
{% else %}
  <hr class="dingbat related" />
{% endif %}
