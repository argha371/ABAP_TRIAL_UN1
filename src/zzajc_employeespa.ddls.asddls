@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZZAJEmployeesPA'
}
@AccessControl.authorizationCheck: #CHECK
define root view entity ZZAJC_EMPLOYEESPA
  provider contract TRANSACTIONAL_QUERY
  as projection on ZZAJR_EMPLOYEESPA
  association [1..1] to ZZAJR_EMPLOYEESPA as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  EmpID,
  Name,
  Age,
  DateOfJoining,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  SalaryCurr,
  @Semantics: {
    Amount.Currencycode: 'SalaryCurr'
  }
  Salary,
  Active,
  CreatedBy,
  CreatedAt,
  ChangedBy,
  ChangedAt,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
