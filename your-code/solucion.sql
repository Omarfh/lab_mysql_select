-- Challenge 2:
SELECT au.au_id as 'author_ID',
au.au_lname as 'last_name',
au.au_fname as 'first_name',
ti.title, pu.pub_name as 'publisher', 
COUNT(pu.pub_id) as 'title_count'
FROM publications.authors au
INNER JOIN publications.titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id
LEFT JOIN publications.publishers pu ON ti.pub_id = pu.pub_id
GROUP BY ti.title
ORDER BY author_ID DESC;

SELECT SUM(title_count)
	FROM (
	SELECT au.au_id as 'author_ID',
	au.au_lname as 'last_name',
	au.au_fname as 'first_name',
	ti.title, pu.pub_name as 'publisher', 
	COUNT(pu.pub_id) as 'title_count'
	FROM publications.authors au
	INNER JOIN publications.titleauthor ta ON au.au_id = ta.au_id
	LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id
	LEFT JOIN publications.publishers pu ON ti.pub_id = pu.pub_id
	GROUP BY ti.title
	ORDER BY author_ID DESC
    ) as tc;

-- Challenge 3: 
CREATE TEMPORARY TABLE publications.sales_per_title
SELECT title_id, SUM(qty) as 'sales_per_title'
FROM publications.sales
GROUP BY title_id;


SELECT au.au_id, au_lname, au_fname, spt.sales_per_title as 'total'
FROM publications.authors au
LEFT JOIN publications.titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN publications.sales_per_title spt ON ta.title_id = spt.title_id
GROUP BY au.au_id
ORDER BY total DESC
LIMIT 3;

-- Challenge 4:

SELECT au.au_id, au_lname, au_fname, IFNULL(spt.sales_per_title, 0) as 'total'  
FROM publications.authors au
LEFT JOIN publications.titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN publications.sales_per_title spt ON ta.title_id = spt.title_id
GROUP BY au.au_id
ORDER BY total DESC;

-- Bonus challenge


SELECT au.au_id, au_lname, au_fname, 
IFNULL((ti.advance * ta.royaltyper/100) + (ti.price * spt.sales_per_title * 
ti.royalty / 100 * ta.royaltyper / 100), 0) as 'profit'
FROM publications.authors au
LEFT JOIN publications.titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id

LEFT JOIN publications.sales_per_title spt ON ta.title_id = spt.title_id
ORDER BY profit DESC
LIMIT 3;
