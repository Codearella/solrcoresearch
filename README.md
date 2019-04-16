# SolrCoreSearch
This is an ASP.NET Core MVC search web app that uses a Apache Solr (Lucene) server for the backend.

## Prerequisites:

1. Windows 10 *(Other versions may also work but have not been tested.)*
2. Java 8 or later *(Verify using **java --version** from the command prompt.)*         	
3. curl version 7.55.1 or later
4. solr-8.0.0 *(For Windows, use the solr-8.0.0.zip version of the file.)*
      http://lucene.apache.org/solr/downloads.html
     

## Install the Solr server on a Windows device:

1. In command prompt, navigate to the directory with the unzipped solr-8.0.0 files (e.g. C:\solr-8.0.0). 
2. If not already started, start the Solr server in cloud mode:
~~~~
C:\solr-8.0.0>bin\solr.cmd start -e cloud  
Welcome to the SolrCloud example!

This interactive session will help you launch a SolrCloud cluster on your local workstation.
To begin, how many Solr nodes would you like to run in your local cluster? (specify 1-4 nodes) [2]:
~~~~
3. Press **enter** to accept the default number of nodes (2). 
~~~~
Ok, let's start up 2 Solr nodes for your example SolrCloud cluster.
Please enter the port for node1 [8983]:
~~~~
4. Press **enter** to accept the default port (8983).
~~~~
Please enter the port for node2 [7574]:
~~~~
5. Press **enter** to accept the default port (7574).
6. Wait while Solr starts up each node. When complete, open http://localhost:8983/solr/#/ in your browser and verify that the Solr dashboard appears.

## Configure the "Movies" collection on the Solr server.

1. Copy the "movies" folder from the GitHub repo into the 'solr-8.0.0\example\' folder (e.g. C:\solr-8.0.0\example\movies). The movies folder should contain the following files:
~~~~
SetupMovies.bat
movies.csv
~~~~
2. Double-click on SetupMovies.bat. This file will create a new collection, configure fields, and index in the data from the movies.csv file.
3. To verify that the data was successfully processed, open http://localhost:8983/solr/#/movies/query and press the "Execute Query" button. JSON records should be returned and the numFound value should indicate that 45403 records were found.

## Run the SolrCoreSearch web app:

1. Clone the project from the GitHub repository. 
2. Install dependencies using nuget. 
3. Compile and run the app.
4. Now you're ready to search!



