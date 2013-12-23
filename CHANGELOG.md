# Changelog

## 3.0 / December 23, 2013

Changes all fetching to paginated HTTP endpoints to return a proxy so that you can control
what you load. This causes breaking changes on some parts of the API.

Adds method to get check if the authenticated user is following a list (`List#following?`).

Adds support for fetching clips by URL or created after time.

Adds new `#fetch` method that works like `#all` but better reflects the use of the method.

Removes `#total_count` on fetched collections because it's been deprecated:
https://github.com/kippt/api-documentation/blob/c104158674e55a4c103b93ccd41233e9a6daea0a/basics/pagination.md

Improves test coverage.

Deprecates support for Ruby 1.8.7.

## 2.0.1 / August 6, 2013

Adds ability to fetch the clips for a list. Contributed by [Darep](https://github.com/Darep).

## 2.0 / July 7, 2013

After being long time in development this update adds support for all the
[new Kippt APIs](http://blog.kippt.com/2013/04/10/say-hi-to-api-and-apps/).

README has been updated to reflect the additions to the API. There has also
been plenty of refactoring done under the covers.

## 1.1 / July 20, 2012

Changes in response to feedback from [Matias Korhonen](https://github.com/k33l0r):

* When adding new lists/clips the object is updated with data received from the service
* Collections of lists & clips are Enumberable

## 1.0 / June 17, 2012

Initial official release.
