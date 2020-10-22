import Paper from "@material-ui/core/Paper/Paper";
import React from "react";
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
}));

function GameGrid({grid}) {
    const classes = useStyles();
    return(
        <Grid container className={classes.root} spacing={2}>
            <Grid item xs={12}>
                <Grid container justify="center" spacing={2}>
                    {grid.map((value, id) => (
                        <Grid key={id}container justify="center" spacing={0.2}>
                            {value.map((element, id) => (
                            <Grid key={id} item>
                                <Paper className={classes.paper} >
                                    {{element} !== null && <div>
                                         {element}
                                    </div>}
                                    {{element} == null && <div>__</div>}
                                </Paper>
                            </Grid>
                        ))}
                        </Grid>
                    ))}
                </Grid>
            </Grid>
        </Grid>
    )
}
export default GameGrid