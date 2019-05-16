    function initParent() {
    
        function createGrid() {

          var facilityDataSource = new kendo.data.DataSource({
              type: "jsdo",
              serverFiltering: true,
              pageSize: 10,
              serverPaging: true,
              serverSorting: true,
              transport: {
                jsdo: "SIFacility",
                countFnName: "count"
              },
              error: function(e) {
                console.log('Error: ', e);
              }
            });

          // select the "grid" div with jQuery and turn it into a Kendo UI Grid
          $('#grid').kendoGrid({
            // all Kendo UI widgets use a DataSource to specify which data to display
            dataSource: facilityDataSource,
            sortable: true, 
            editable: 'inline',
            toolbar: ['create', 'cancel', 'save'],
            filterable: {
                            extra: false,
                            operators: {
                                string: {
                                    startswith: "Starts with",
                                    eq: "Is equal to",
                                    neq: "Is not equal to"
                                }
                            }
                        },
            pageable: {
              refresh: true,
              pageSizes: true,
              pageSize: 10,             
              buttonCount: 5
            },     
            detailInit: detailInit,    
            columns: [
              //{ field: 'CustNum',  title: 'Cust Num', width: 100, filterable: false, editable: false, nullable: true },
              { field: 'Type' },
              { field: 'Name' },
              { field: 'Description' },
			  { command: ["edit", "destroy"], title: "&nbsp;", width: "250px" }
            ]
          });      
        }
    
        try {
            var serviceURI = "http://localhost:8081/licenta_rest_2019/rest",
                jsdoSettings = {
                    serviceURI: serviceURI,
                    catalogURIs: serviceURI + "/FacilityService.json"
                },
                jsdosession,
                promise;

            // create a new session object
            jsdosession = new progress.data.JSDOSession(jsdoSettings);
            promise = jsdosession.login("", "");
                
            promise.done(function(jsdosession, result, info){
                jsdosession.addCatalog(jsdoSettings.catalogURIs)
                    .done(function(jsdosession, result, details){
                        createGrid();
                    })
                    .fail(function(jsdosession, result, details){
                        alert("Error while executing addCatalog()." + jsdoSettings.catalogURIs);
                });
            });
            promise.fail(function(jsdosession, result, info){
                alert("Error while executing login()." + jsdoSettings.catalogURIs);      
            });        
        }
        catch (e) {
            alert("Error instantiating objects: " + e);
        }
    }

    $(document).ready(function() {
        $("#menu").kendoMenu();
		initParent();
    });
  $(function(){

    $(document.body).addClass("k-content");

  });
