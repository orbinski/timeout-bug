using System.ComponentModel.DataAnnotations;
using epi_alloy_mvc.Models.Pages;
using EPiServer.Web;
using Microsoft.AspNetCore.Html;

namespace epi_alloy_mvc.Models.ViewModels;

public class ContactBlockModel
{
    [UIHint(UIHint.Image)]
    public ContentReference Image { get; set; }

    public string Heading { get; set; }

    public string LinkText { get; set; }

    public IHtmlContent LinkUrl { get; set; }

    public bool ShowLink { get; set; }

    public ContactPage ContactPage { get; set; }
}
