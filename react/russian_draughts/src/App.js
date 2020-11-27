import logo from './logo.svg';
import './App.css';
import Container from "@material-ui/core/Container";
import React from "react";
import Grid from "./components/Grid";

function App() {
    const [gr, setGrid] = React.useState([["black", null, null, null], [null, "black", null, null], [null, null, null, null], [null, "white", null, "white"]]);
    const [turn, setTurn] = React.useState("white")
    const [isPlayersTurn, setIsPlayersTurn] = React.useState(true)
    const [selected, setSelected] = React.useState(null);
    async function getGrid(){

        var requestOptions = {
            method: 'GET',
            redirect: 'follow'
        };

        fetch("http://localhost:3000/field/checkers", requestOptions)
            .then(response => response.json())
            .then(result => {
                console.log(result)
                setGrid(result.grid)
            })
            .catch(error => console.log('error', error));
    }
    const setGr = (newGrid) =>{
        setGrid(newGrid)
    }
      return (
        <div className="App">
            <button onClick={getGrid}>
                Новая игра
            </button>
            <Container>
                <Grid setGrid={setGr} grid={gr} turn={turn} selected={selected} setSelected={setSelected} isPlayersTurn={isPlayersTurn}/>
            </Container>
        </div>
      );
}

export default App;
