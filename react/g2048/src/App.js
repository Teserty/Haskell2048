import React from 'react';
import './App.css';
import makeStyles from "@material-ui/core/styles/makeStyles";
import GameGrid from "./GameGrid";


const useStyles = makeStyles((theme) => ({
    root: {
        flexGrow: 1,
    }
}));
function App() {
    document.onkeydown = checkKey;
    async function getGrid(){

        var requestOptions = {
            method: 'GET',
            redirect: 'follow'
        };

        fetch("http://localhost:3000/", requestOptions)
            .then(response => response.json())
            .then(result => {
                console.log(result)
                setGrid(result.grid)
            })
            .catch(error => console.log('error', error));

        /*fetch('http://localhost:3000/')
            .then((response) => {
                return response.json();
            })
            .then((data) => {

                alert(grid)
            });*/
    }
    async function post(turn) {
        var myHeaders = new Headers()
        var raw = {
            "turn": turn,
            "sendgr": grid

        };
        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: JSON.stringify(raw),
            redirect: 'follow'
        };
        fetch("http://localhost:3000/", requestOptions)
            .then(response => response.json())
            .then(result => {
                setGrid(result.sendGrid)
            })
            .catch(error => console.log('error', error));
    }

    function checkKey(e) {
        e = e || window.event;
        let ckey = ""
        if (e.keyCode == '87') {
            ckey = "w"
        } else if (e.keyCode == '83') {
            // down arrow
            ckey = "s"
        } else if (e.keyCode == '65') {
            // left arrow
            ckey = "a"
        } else if (e.keyCode == '68') {
            // right arrow
            ckey = "d"
        }
        if(ckey == "w" || ckey == "a" || ckey == "s" || ckey =="d"){
            post(ckey)
        }

    }
    const classes = useStyles();
    const [grid, setGrid] = React.useState([[null, null, null, null], [null, null, null, null], [null, null, null, null], [null, null, null, null]]);
    return (
    <div className="App">

      <header className="App-header">
          <button onClick={getGrid}>
              Новая игра
          </button>
          <GameGrid grid={grid}/>
      </header>
    </div>
  );
}

export default App;
