#How to automate a PUBMED search?

#Suppose your search term is ( (term1) AND (term2) AND (term3))
#Then the, results URL for that search is
#. https://pubmed.ncbi.nlm.nih.gov/?term=%28%28term1%29+AND+%28term2%29%29+AND+%28term3%29

#open paranthesis = %28
#close paranthesis = %29

# Given a list of terms say from a CSV file,
#first we need to construct the pubmed URL for the search term

#Use rvest to read html, if it has the term "zero results",
#that means we didn't find any articles related to that search term.
