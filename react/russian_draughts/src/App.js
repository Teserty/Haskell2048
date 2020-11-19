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
    const setGr = (newGrid) =>{
        setGrid(newGrid)
    }
      return (
        <div className="App">
            <Container>
                <Grid setGrid={setGr} grid={gr} turn={turn} selected={selected} setSelected={setSelected} isPlayersTurn={isPlayersTurn}/>
            </Container>
        </div>
      );
}

export default App;
