Feature: Crud para crear Usuario

  Background:
    * url 'https://gorest.co.in/public/v2'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'
    * def req_headers = {Authorization: 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'}
    * def dataGenerator = Java.type('Utils.DataGenerator')  
    * def payload =
        """
            {
                "gender":"male", 
                "status":"active"
            }
        """    
    * payload.name = dataGenerator.getUserRandom().name
    * payload.email = dataGenerator.getUserRandom().email 

  @Regresion @PostUser @User
  Scenario: Crear un nuevo usuario exitosamente
    Given path 'users'
    And request
    """
    {
      "name": "Tenali Ramakrishna",
      "gender": "male",
      "email": "8testing99@gmail.com",
      "status": "active"
    }
    """
    When method post
    Then status 201
    And match response ==
    """
    {
      id: '#number',
      name: "Tenali Ramakrishna",
      email: "8testing99@gmail.com",
      gender: "male",
      status: "active"
    }
    """
  @Regresion @ @PostUserDinamic
  Scenario: Crear Usuario Nuevo usando FakeData
    * def emailFake = dataGenerator.getEmailRandom()
    * def nameFake = dataGenerator.getRandonName()
    Given path 'users'
    And request {"name":#(nameFake), "gender":"male", "email":#(emailFake), "status":"active"}
    When method Post
    Then status 201
    And match response ==
    """
        {
        "id": "#number",
        "name": "#string",
        "email": "#string",
        "gender": "#string",
        "status": "#string"
        }

    """
  @Regresion @Smock @GetUser
  Scenario: Obtener Datos de un Usuario
    Given path 'users'
    And request payload
    When method Post
    Then status 201
    * def userid = response.id
    * print userid
    Given path 'users/' , userid
    And headers req_headers
    When method Get
    Then status 200
    And match response.email == payload.email
  @Regresion @Smock @PutUser
  Scenario: Actualizar Datos de un Usuario
    Given path 'users'
    And request payload
    When method Post
    Then status 201
    * def userid = response.id
    Given path "users/" , userid
    And headers req_headers
    And request payload
    And payload.name= 'Nombre Modificado' 
    When method PUT
    Then status 200
    And match response.name == 'Nombre Modificado'
  @Regresion @Smock @DeleteUser
  Scenario: Eliminar Datos de un Usuario
    Given path 'users'
    And header karate-name = 'Crear Usuario'    
    And request payload
    When method Post
    Then status 201
    * def userid = response.id
    Given path "users/" , userid
    And headers req_headers
    When method Delete
    Then status 204    