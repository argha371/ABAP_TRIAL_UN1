@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.deliveryClass: #APPLICATION_DATA
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZZAJEmployeesPA'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root table entity ZZAJR_EMPLOYEESPA
{
  key UUID : SYSUUID_X16;
  EmpID : abap.char( 50 );
  Name : abap.char( 50 );
  Age : abap.int8;
  DateOfJoining : abap.datn;
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  SalaryCurr : abap.cuky;
  @Semantics.amount.currencyCode: 'SalaryCurr'
  Salary : abap.curr( 17, 2 );
  Active : ABAP_BOOLEAN;
  CreatedBy : abap.char( 50 );
  CreatedAt : abap.utclong;
  ChangedBy : abap.char( 50 );
  ChangedAt : abap.utclong;
  @Semantics.user.createdBy: true
  LocalCreatedBy : ABP_CREATION_USER;
  @Semantics.systemDateTime.createdAt: true
  LocalCreatedAt : ABP_CREATION_TSTMPL;
  @Semantics.user.localInstanceLastChangedBy: true
  LocalLastChangedBy : ABP_LOCINST_LASTCHANGE_USER;
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LocalLastChangedAt : ABP_LOCINST_LASTCHANGE_TSTMPL;
  @Semantics.systemDateTime.lastChangedAt: true
  LastChangedAt : ABP_LASTCHANGE_TSTMPL;
}
