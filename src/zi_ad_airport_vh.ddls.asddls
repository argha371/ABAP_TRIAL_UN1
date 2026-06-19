@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airport Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity zi_ad_airport_vh
  as select from /dmo/airport
{
      @Search.defaultSearchElement: true

  key airport_id as AirportId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      name       as Name,
      @Search.defaultSearchElement: true
      city       as City,
      @Search.defaultSearchElement: true
      country    as Country
}
