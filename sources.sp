dashboard "Sources" {

  tags = {
    service = "Hacker News"
  }

container {
    
    text {
      width = 8
      value = replace(
        replace(
          "${local.menu}",
          "__HOST__",
          "${local.host}"
        ),
        "[Sources](${local.host}/hackernews.dashboard.Sources)",
        "Sources"
      )
    }

  }  




  table {
    width = 6
    query = query.domains
    column "domain" {
      href = "${local.host}/hackernews.dashboard.Sources?input.domain={{.'domain'}}"
    }    
  }

  container {
    width = 6

    container  {
      
      container {
      
        input "domain" {
          width = 6
          placeholder = "search or choose domain"
          sql = <<EOQ
            with domains as (
              select distinct
                substring(url from 'http[s]*://([^/$]+)') as domain
              from
                hn
            )
            select
              domain as label,
              domain as value
            from
              domains
            where
              domain is not null
            order by
              domain
          EOQ    
        }

        text "source_examples" {
          width = 6
          value = <<EOT
Examples: 
[www.nytimes.com](${local.host}/hackernews.dashboard.Sources?input.domain=www.nytimes.com),
[github.com](${local.host}/hackernews.dashboard.Sources?input.domain=github.com),
[simonwillison.net](${local.host}/hackernews.dashboard.Sources?input.domain=simonwillison.net)
        EOT
        }

      }

      chart {
        args = [
          self.input.domain
        ]
        query = query.domain_detail
        axes {
          y {
            title {
              value = "stories"
            }
          }
        }
      }

      table {
        args = [ self.input.domain  ]
        query = query.source_detail
        column "link" {
          href = "https://news.ycombinator.com/item?id={{.'link'}}"
        }
        column "url" {
          wrap = "all"
        } 
        column "title" {
          wrap = "all"
        } 
      }

    }

  }

}