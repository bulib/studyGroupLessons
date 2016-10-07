% Accessing Data Via RESTful APIs
% Chris Holden
% 09/21/2016

# Some acronyms

## [API](https://en.wikipedia.org/wiki/Application_programming_interface)

Application Programming Interface

* Defines access methods to a program, service, libraries, frameworks, etc.
* Restaurant analogy
    * Customers (users)
    * Chefs (service)
    * Wait staff (API)

## [REST](https://en.wikipedia.org/wiki/Representational_state_transfer)

Representational state transfer

* HTTP specification
    * POST -> create
    * GET -> retrieve
    * PUT -> update
    * DELETE -> delete

## [JSON](https://en.wikipedia.org/wiki/JSON)

JavaScript Object Notation

``` json
{
  "email": "production@email.com",
  "first_name": "Production",
  "last_name": "Person",
  "roles": [
    "user",
    "production"
  ],
  "username": "production"
}
```

## [cURL](https://en.wikipedia.org/wiki/CURL)

* Library and command line application
* Easy way of demonstrating RESTful APIs

# Example - [Github](https://developer.github.com/v3/)

## Github

[cURL tutorial with Github's API by `caspyin`](https://gist.github.com/caspyin/2288960)

## GET

``` bash
> curl https://api.github.com/users/ceholden
{
  "login": "ceholden",
  "id": 3585769,
  "avatar_url": "https://avatars.githubusercontent.com/u/3585769?v=3",
  "gravatar_id": "",
  "url": "https://api.github.com/users/ceholden",
  "html_url": "https://github.com/ceholden",
  "followers_url": "https://api.github.com/users/ceholden/followers",
  "following_url": "https://api.github.com/users/ceholden/following{/other_user}",
  "gists_url": "https://api.github.com/users/ceholden/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/ceholden/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/ceholden/subscriptions",
  "organizations_url": "https://api.github.com/users/ceholden/orgs",
  "repos_url": "https://api.github.com/users/ceholden/repos",
  "events_url": "https://api.github.com/users/ceholden/events{/privacy}",
  "received_events_url": "https://api.github.com/users/ceholden/received_events",
  "type": "User",
  "site_admin": false,
  "name": "Chris Holden",
  "company": "Boston University",
  "blog": "ceholden.github.io",
  "location": "Boston, MA",
  "email": null,
  "hireable": null,
  "bio": null,
  "public_repos": 38,
  "public_gists": 4,
  "followers": 57,
  "following": 26,
  "created_at": "2013-02-13T16:02:09Z",
  "updated_at": "2016-09-17T21:39:56Z"
}
```

## Authenticate

For more detailed information, you'll probably need to authenticate.

* Simple username and password:
    * `curl --user "USER:PASSWORD" https://api.github.com/users/USER`
* OAuth2
    * [Create a personal access token](https://github.com/settings/tokens)
    * `curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com/users/ceholden`

## GET

``` bash
# Add the -s so we can grep the output without progress bar
> curl -s -H "Authorization: token OAUTH-TOKEN" https://api.github.com/users/ceholden/followers | grep "login"
    "login": "Woodstonelee",
    "login": "schoi-bu",
    "login": "mwdlamini",
    "login": "sw-rifai",
    "login": "xjtang",
    "login": "valpasq",
    "login": "parevalo",
...
```

# Example - USGS EROS Data Center's ESPA API

## [ESPA API](https://github.com/USGS-EROS/espa-api)

Following examples on https://github.com/USGS-EROS/espa-api

Need USGS account to follow along. Create on here: https://ers.cr.usgs.gov/register/

## Check user status

`GET /api/v0/user`

``` bash
> curl --user username:password https://espa.cr.usgs.gov/api/v0/user
{
  "email": "production@email.com",
  "first_name": "Production",
  "last_name": "Person",
  "roles": [
    "user",
    "production"
  ],
  "username": "production"
}
```

## Available products

`GET /api/v0/available-products/<product_id>`

``` bash
> curl --get --user username:password https://espa.cr.usgs.gov/api/v0/available-products/LE70290302003123EDC00
{
    "etm7": {
        "inputs": [
            "LE70290302003123EDC00"
        ],
        "products": [
            "source_metadata",
            "l1",
            "toa",
            "bt",
            "cloud",
            "sr",
            "lst",
            "swe",
            "sr_ndvi",
            "sr_evi",
            "sr_savi",
            "sr_msavi",
            "sr_ndmi",
            "sr_nbr",
            "sr_nbr2",
            "stats"
        ]
    }
}
```

## Check your orders

`GET /api/v0/list-orders/<email>`

``` bash
> curl --user username:password https://espa.cr.usgs.gov/api/v0/list-orders
{
  "orders": [
    "production@email.com-101015143201-00132",
    "production@email.com-101115143201-00132"
  ]
}
```

## Order data

`POST /api/v0/order`

``` bash
curl --user username:password -d '{"olitirs8": {
                                                    "inputs": ["LC8027029201533LGN00"],
                                                    "products": ["sr"]
                                                 },
...
                                     https://espa.cr.usgs.gov/api/v0/order

{
 "orderid": "production@email.com-101015143201-00132"
}
```

## ESPA API - Build a client on top of API

Currently building Python library and CLI for interacting with ESPA API using `requests` library: [here](https://github.com/ceholden/espa-api-client)

## ESPA API Client

``` python
from espa_api_client.espa import ESPA_API

api = ESPA_API('user', 'password')
```

## ESPA API Client

``` bash
> espa
Usage: espa [OPTIONS] COMMAND [ARGS]...

  ESPA API CLI

Options:
  --version        Show the version and exit.
  -v, --verbose    Be verbose
  -q, --quiet      Ignore warnings
  --user TEXT      USGS ESPA username
  --password TEXT  USGS ESPA password
  -h, --help       Show this message and exit.

Commands:
  info    Return information for ESPA system
  orders  Return information for ESPA orders
```

## ESPA API Client

``` bash
> espa -q info user
{'email': 'cholden888@gmail.com',
 'first_name': 'Chris',
 'last_name': 'Holden',
 'roles': ['active'],
 'username': 'cholden888'}
```

## ESPA API Client

``` bash
espa -q orders list bullocke@bu.edu
['bullocke@bu.edu-0101606083446',
 'bullocke@bu.edu-0101606083601',
 'bullocke@bu.edu-0101608100639',
 'bullocke@bu.edu-0101608100649',
 'bullocke@bu.edu-03082016-085836',
 'bullocke@bu.edu-08212014-105953',
 'bullocke@bu.edu-08212014-110946',
 'bullocke@bu.edu-08252014-111657',
 'bullocke@bu.edu-08252014-134532',
 'bullocke@bu.edu-08252014-145839',
 'bullocke@bu.edu-09112014-104944',
 'bullocke@bu.edu-09122014-083954',
 'bullocke@bu.edu-09262014-140840',
 'bullocke@bu.edu-10092014-102317',
 'bullocke@bu.edu-11042014-125733',
 'bullocke@bu.edu-11112014-120710',
 'bullocke@bu.edu-11112014-130232',
 'bullocke@bu.edu-11182014-114529',
 'bullocke@bu.edu-11192014-072402',
 'bullocke@bu.edu-11262014-085320',
 'bullocke@bu.edu-12012014-105506',
 'bullocke@bu.edu-12022014-095125',
 'bullocke@bu.edu-12042014-074815',
 'bullocke@bu.edu-12052014-104934',
 'bullocke@bu.edu-12102014-083958',
 'bullocke@bu.edu-12102014-084027',
 'bullocke@bu.edu-12162014-095504',
 'bullocke@bu.edu-01052015-105149',
 'bullocke@bu.edu-01062015-123536',
 'bullocke@bu.edu-01072015-083228',
 'bullocke@bu.edu-01072015-101950',
 'bullocke@bu.edu-01092015-103325',
 'bullocke@bu.edu-01132015-090841',
 'bullocke@bu.edu-01152015-090006',
 'bullocke@bu.edu-01152015-091516',
 'bullocke@bu.edu-01152015-093029',
 'bullocke@bu.edu-01152015-093701',
 'bullocke@bu.edu-01202015-153300',
 'bullocke@bu.edu-01202015-154347',
 'bullocke@bu.edu-02172015-134130',
 'bullocke@bu.edu-03032015-141646',
 'bullocke@bu.edu-03182015-151529',
 'bullocke@bu.edu-03232015-113804',
 'bullocke@bu.edu-05152015-153445',
 'bullocke@bu.edu-05192015-113151',
 'bullocke@bu.edu-05202015-123313',
 'bullocke@bu.edu-05212015-084518',
 'bullocke@bu.edu-05212015-085613',
 'bullocke@bu.edu-05222015-113221',
 'bullocke@bu.edu-05282015-130738',
 'bullocke@bu.edu-06092015-161953',
 'bullocke@bu.edu-06092015-162109',
 'bullocke@bu.edu-06092015-162655',
 'bullocke@bu.edu-06162015-094211',
 'bullocke@bu.edu-06182015-193320',
 'bullocke@bu.edu-06182015-192126',
 'bullocke@bu.edu-06182015-194928',
 'bullocke@bu.edu-07012015-095807',
 'bullocke@bu.edu-07012015-093149',
 'bullocke@bu.edu-07012015-093740',
 'bullocke@bu.edu-07012015-100719',
 'bullocke@bu.edu-07012015-102811',
 'bullocke@bu.edu-07012015-105729',
 'bullocke@bu.edu-07012015-111157',
 'bullocke@bu.edu-07012015-112043',
 'bullocke@bu.edu-07012015-112532',
 'bullocke@bu.edu-07012015-112802',
 'bullocke@bu.edu-07212015-081204',
 'bullocke@bu.edu-07242015-140124',
 'bullocke@bu.edu-07282015-083210',
 'bullocke@bu.edu-0101507290004',
 'bullocke@bu.edu-07302015-145151',
 'bullocke@bu.edu-08052015-130939',
 'bullocke@bu.edu-08112015-181024',
 'bullocke@bu.edu-08112015-181745',
 'bullocke@bu.edu-08132015-110635',
 'bullocke@bu.edu-09292015-191237',
 'bullocke@bu.edu-09302015-100440',
 'bullocke@bu.edu-09302015-100046',
 'bullocke@bu.edu-10062015-163309',
 'bullocke@bu.edu-10062015-104827',
 'bullocke@bu.edu-10062015-164500',
 'bullocke@bu.edu-09292015-191308',
 'bullocke@bu.edu-10132015-123932',
 'bullocke@bu.edu-10162015-100752',
 'bullocke@bu.edu-10172015-091206',
 'bullocke@bu.edu-10162015-100959',
 'bullocke@bu.edu-10142015-164958',
 'bullocke@bu.edu-10132015-124144',
 'bullocke@bu.edu-10132015-124307',
 'bullocke@bu.edu-10162015-100852',
 'bullocke@bu.edu-01122016-135142',
 'bullocke@bu.edu-01252016-193204',
 'bullocke@bu.edu-01292016-141230',
 'bullocke@bu.edu-02152016-184717',
 'bullocke@bu.edu-02192016-094532']
```

## ESPA API Client

More functionality coming... sometime.

* Find available products for a Landsat ID
* Put in an order for a product
    * Ease of use: specify EPSG code for projection, etc.
* Check up on data orders
* Download
* Above functionality will facilitate "near real time" ordering system via `cron` job

# References

## Python

[requests](http://docs.python-requests.org/en/master/)

``` python
>>> r = requests.get('https://api.github.com/user', auth=('user', 'pass'))
>>> r.status_code
200
>>> r.headers['content-type']
'application/json; charset=utf8'
>>> r.encoding
'utf-8'
>>> r.text
u'{"type":"User"...'
>>> r.json()
{u'private_gists': 419, u'total_private_repos': 77, ...}
```

## R

[jsonlite](https://cran.r-project.org/web/packages/jsonlite/vignettes/json-apis.html)

``` R
> library(jsonlite)
> hadley_orgs <- fromJSON("https://api.github.com/users/hadley/orgs")
> hadley_repos <- fromJSON("https://api.github.com/users/hadley/repos")
> gg_commits <- fromJSON("https://api.github.com/repos/hadley/ggplot2/commits")
> gg_issues <- fromJSON("https://api.github.com/repos/hadley/ggplot2/issues")
> paste(format(gg_issues$user$login), ":", gg_issues$title)

[1] "aphalo            : Changed stacking order"                                                              
[2] "Ax3man            : geom_hex no longer recognizes ..count.."                                             
[3] "ironv             : geom_dotplot dot layout with groups"
```
