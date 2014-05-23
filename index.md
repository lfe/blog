---
layout: default
title: LFE News &amp; Updates
tagline: A Microblog for the Syntaxless Ones
---
{% include JB/setup %}

<h2>All Pages</h2>

{% for post in site.posts offset: 0 limit: 50 %}
<div class="row">
  <div class="span7">
    <div class="row">
      <div class="span5">
		    <h4>
          <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
        </h4>
        <p>
          {{ post.excerpt }}
        </p>
		    <p>
          <i class="icon-calendar"></i> {{ post.date | date: "%B %e, %Y" }}
          </a>
		  | <i class="icon-tags"></i> Tags :{% for tag in post.tags %} <a href="/tags/{{ tag }}" rel="tooltip" title="View posts tagged with &quot;{{ tag }}&quot;"><span class="label label-info">{{ tag }}</span></a>  {% if forloop.last != true %} {% endif %} {% endfor %}
        </p>
        <p><a href="{{ post.url }}">Read more</a></p>
      </div>
    </div>
	<hr>
  </div>
</div>
{% endfor %}
