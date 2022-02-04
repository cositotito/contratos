// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.9;


contract Owner {
    address internal owner;

    // obtengo el address creador
    function getOwner() public view returns(address){
        return owner;
    }

    // solo el creador puede agregar en cualquier caso  
     modifier onlyOwner(){
        require(getOwner()==msg.sender, "solo el creado puede modificar.");
        _;
    }

    // modifico el address creador
    function setOwner(address _owner) public  onlyOwner(){
        owner=_owner;
    }

}

contract base is Owner {

    uint public longitud=0; // para saber que tamaño tiene actualmente el mapping
    struct typeData{
        uint timestamblockchain; // timestamp de la blockchain (para saber en que tiempo se creo)
        uint timestamcreation; // timestamp de los datos tomados en ese momento
        uint dato0; // dato del aparato 
    }
    mapping(uint => typeData) allData;

    constructor(){
        owner= msg.sender; // al crear el contrato agrego quien es el creador        
    }    

    // verifico que no exista dato en el arreglo
    // para no sobre escribir algun dato por error
    modifier noDato(uint index){
        require(allData[index].dato0==0, "tiene dato.");
        _;
    }

    // agrega dato siempre y cuando no tenga datos el mapping
    // [timestamcreation,dato0]
    // ej: [11231231232312,155]
    function appendData(uint index, uint[] memory dato0) public noDato(index) onlyOwner() { 
        allData[longitud+index]= typeData(block.timestamp,dato0[0],dato0[1]);       
    }

    // le paso una matriz para poder agregarlo dentro de la estructura    
    // [dato, timestamcreation]
    // [[11231231232312,155],[1,2],[23,43],[54,33],[23,2],[2,3]]
    // [[9112333311,155],[144444,2],[24333343,43],[5666664,33],[222223,2],[111112,3]]
    function forAppendData(uint[][] memory dato0) public onlyOwner()  {
        for(uint i=0; i<dato0.length; i++){     
            allData[longitud+i]= typeData(block.timestamp,dato0[i][0],dato0[i][1]);
        }
        longitud= longitud+dato0.length;   // actualizo la longitud del arreglo    
    }

    // obtengo datos dentro de la estructura dando la posicion que quiero 
    function getData(uint index) public view returns(uint,uint,uint){        
        return (allData[index].dato0,allData[index].timestamcreation,allData[index].timestamblockchain); 
    }

    



}