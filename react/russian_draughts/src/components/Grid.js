import Tile from "./Tile"
import React from "react";
import Paper from "@material-ui/core/Paper/Paper";
import Grid from "@material-ui/core/Grid";
import makeStyles from "@material-ui/core/styles/makeStyles";
const useStyles = makeStyles((theme) => ({
    paper: {
        height: 140,
        width: 140,
    },
    texts: {
        textAlign: 'center',
        position: 'absolute',
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
        margin: 'auto',
        maxWidth: 100,
        maxHeight: 100,
    },
    white: {
        backgroundImage: 'white'
    },
    black: {
        backgroundColor: 'black'
    }

}));

function GameGrid({grid, turn, selected, setSelected, isPlayersTurn, setGrid}) {
    const classes = useStyles();
    let gr = grid.map((line, index1)=>{
        return line.map((elem, index2)=>{
            return <Tile index1={index1} index2={index2} elem={elem}/>
        })
    })
    return (
        <Grid container className={classes.root} spacing={2}>
            <Grid item xs={12}>
                <Grid container justify="center" spacing={2}>
                    {grid.map((value, id1) => (
                            <Grid key={id1}container justify="center" spacing={0.2}>
                                {value.map((element, id2) => (
                                    <Grid key={id2} item>
                                        <Paper className={classes.paper} >
                                            <Tile setGrid={setGrid} grid={grid} index1={id1} index2={id2} elem={element} turn={turn} selected={selected} setSelected={setSelected} isPlayersTurn={isPlayersTurn}/>
                                        </Paper>
                                    </Grid>
                                ))}
                            </Grid>
                    ))}
                </Grid>
            </Grid>
        </Grid>
    );
}

export default GameGrid;
