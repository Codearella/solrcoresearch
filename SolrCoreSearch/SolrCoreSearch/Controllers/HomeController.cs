using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SolrCoreSearch.Models;
using System.Net.Http;

namespace SolrCoreSearch.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }


        public async Task<IActionResult> Search(string q, int start, int rows)
        {
            // Get search result text from the Lucene Solr Server.
            using (var hc = new HttpClient())
            {
                 var searchString = $"http://localhost:8983/solr/movies/select?defType=edismax&sow=false" +
                    $"&q={Uri.EscapeUriString(q)}" +
                    $"&start={Uri.EscapeUriString(start.ToString())}" +
                    $"&rows={Uri.EscapeUriString(rows.ToString())}";                  

                var response = await hc.GetStringAsync(searchString);

                return Content(response, "application/json");
            }
        }


        public async Task<IActionResult> AutocompleteSearch(string q, int rows)
        {
            // Get autocomplete text from the Lucene Solr Server.
            using (var hc = new HttpClient())
            {
                var searchString = $"http://localhost:8983/solr/movies/suggest?" +
                    $"suggest.q={Uri.EscapeUriString(q)}*" +
                    $"&rows={Uri.EscapeUriString(rows.ToString())}";

                var response = await hc.GetStringAsync(searchString);

                return Content(response, "application/json");
            }
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
