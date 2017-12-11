---
layout: page
title: Projects
excerpt: "A list of past and current projects"
search_omit: true
---

<ul class="post-list">
{% for post in site.categories.projects %} 
  <li>
  	<article>
  		<a href="{{ site.url }}{{ post.url }}">{{ post.title }}
  			{% if post.status %}
	  			<span class="status"><i class="fa fa-circle {% if post.status == "Deployed" %}deployed{% endif %}{% if post.status == "Complete" %}complete{% endif %}{% if post.status == "Ongoing - Prototype Complete" %}prototype{% endif %}{% if post.status == "Ongoing - No Prototype Yet" %}no-prototype{% endif %}" aria-hidden="true"></i> Status: {{ post.status }}</span>
  			{% endif %}
  			{% if post.excerpt %}
  				<span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>
  			{% endif %}
  		</a>
  	</article>
  </li>
{% endfor %}
</ul>
