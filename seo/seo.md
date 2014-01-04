# Criteria of how to select the keyword
+ The number of the query phrase searched by people per month. The more, the better.
+ The competititon of the search query phrase. The lower competition level, the better.
+ The degree of the association between the content and the keyword. If the content is the one the customers want, they will stay on the webpage longer. 


# implementation of keywords
## title && description => include the keywords
<title> ... </title>
<meta name="description" content="...">
+ title <= 64
+ description <= 160
## include keywords in the content
+ strong, i, em, tags
## image
+ <img src="img/keywords.jpg" alt="keywords-keywords"> 
## video
+ surround the video, add title, description
## seo-friendly URLs (html file name: e.g. key-word-phrase.html)
+ It is very important to come up a naming structure.
+ folder structure: name the folder name or the html name according to the keywords

# XML Sitemaps
+ www.xml-sitemaps.com
  - 1) Download the sitemap file and upload it into the domain root folder of your site (http://www.openassembly.com/). 
  - 2) Check that sitemap is showing for you at http://www.openassembly.com/sitemap.xml, go to your Google Webmaster account and add your sitemap URL.

# Robots Files and Tags
+ robots.txt
  - User-agent: * (GoogleBot...--make it more specific)
  - Disallow: /private/ (The pages you dont want to be indexed, "/" means any pages, "/private/")
  - Disallow: /sample-page.html
  - Disallow: /images/image.jpg
+ put robots.txt in the root
+ <meta name="robots" content="noindex">

# Linking to New Pages
+ <a href="/related-keywords.html" title="Core keywords">Keywords</a>

# Duplicate Content
+ wwww.mysite.com or home.mysite.com or www.mysite.com/home.html
  - <link href="http://www.mysite.com/home.html" rel="canonical" >
+ index.html or index.html?id=1 or index.html?edition=working

# Pagination
+ in the case that we have many pages for an article
  - the page comes before the current page
  - <link rel="prev" href="http://www.mysite.com/home.html?pg=1">
  - <link rel="prev" href="http://www.mysite.com/home-01.html">
  - <link rel="next" href="http://www.mysite.com/home.html?pg=3">
  - <link rel="next" href="http://www.mysite.com/home-03.html">
  - If this is the first page, we dont need "prev"; if this is the last page, we dont need "next".

# Structured Data
+ schema.org
  - itemscope: everything in the div is related to the item.
  - itemtype: url specifies the type
  - itemprop: property of the item
    <div itemscope itemtype="http://schema.org/Product">
      <img itemprop="image" src="get-fit-on-a-budget.jpg" alt="Book - Get Fit on a Budget">
      <span itemprop="name">Get Fit on a Budget</span>
      <div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
        <span itemprop="ratingValue">4.5</span> out of <span itemprop="bestRating">5</span> stars based on <span itemprop="ratingCount">48</span> user ratings
      </div>

      <div itemprop="offers" itemscope itemtype="http://schema.org/Offer">
        Price: <span itemprop="price">$23.99</span>
      <div>
      <span itemprop="description">This popular new book is full of tips add tricks for exercise routines and diet plans that wont break the bank.</span>
    </div>
+ test on the webmaster--structure testing tools

# Authorship Infomation
+ https://plus.google.com/authorship
+ <h4>by <a href="https://plus.google.com/117946891143736169828?rel=author">Jingen Lin</a></h4> // in the article
+ <link rel="author" href="https://plus.google.com/117946891143736169828">

# Local SEO
<div itemscope itemtype="http://schema.org/LocalBusiness">
  <span itemprop="name">E-learning|online courses --Jingen Lin</span>
  <div itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
    <span itemprop="streetAddress">137 Varick Street 2nd Floor</span>
    <span itemprop="addressLocality">New York</span>, <span itemprop="addressRegion">NY</span>
  </div>
</div>

# Social Snippets (episode 20 & 21)
- facebook
- twitter
