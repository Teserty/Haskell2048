import React from "react";
import Card from "@material-ui/core/Card";
import CardActionArea from "@material-ui/core/CardActionArea";
import CardMedia from "@material-ui/core/CardMedia";
import makeStyles from "@material-ui/core/styles/makeStyles";
const useStyles = makeStyles((theme) => ({
    white: {
        backgroundImage: 'white'
    },
    black: {
        backgroundColor: 'black'
    }

}));

function Tile({setGrid, grid, index1, index2, elem, turn, selected, setSelected, isPlayersTurn}) {
    const classes = useStyles();
    let source;
    if(elem === "black")
        source = "./black.png"
    else if (elem === "white")
        source = "./white.png"
    let cl;
    if (isTileBlack(index1, index2))
        cl = classes.black
    else
        cl = classes.white
    function isTileBlack(index1, index2) {
        return ((index2+index1)%2===0)
    }
    function canGo() {
        //white
        if (turn === "white") {
            let delx = selected[0] - index1
            let dely = selected[1] - index2
            if ((dely === 1 || dely === -1) && delx === 1){
                let temp = grid
                grid[selected[0]][selected[1]] = null
                grid[index1][index2] = "white"
                setGrid(grid)
                setSelected(null)
            }else if(dely === 2 && delx === 2){
                if(grid[selected[0]+1][selected[1]+1] === "black"){
                    grid[selected[0]+1][selected[1]+1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }else if(dely === -2 && delx === 2){
                if(grid[selected[0]-1][selected[1]+1]=== "black"){
                    grid[selected[0]-1][selected[1]+1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }else if(dely === 2 && delx === -2){
                if(grid[selected[0]+1][selected[1]-1] === "black"){
                    grid[selected[0]+1][selected[1]-1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }else if(dely === -2 && delx === -2){
                if(grid[selected[0]-1][selected[1]-1]=== "black"){
                    grid[selected[0]-1][selected[1]-1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }

        }
        //black
        if (turn === "black") {
            let delx = selected[0] - index1
            let dely = selected[1] - index2
            if ((dely === 1 || dely === -1) && delx === -1){
                let temp = grid
                grid[selected[0]][selected[1]] = null
                grid[index1][index2] = "white"
                setGrid(grid)
                setSelected(null)
            }else if(dely === 2 && delx === -2){
                if(grid[selected[0]+1][selected[1]+1] === "white"){
                    grid[selected[0]+1][selected[1]+1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }else if(dely === -2 && delx === -2){
                if(grid[selected[0]-1][selected[1]+1]=== "white"){
                    grid[selected[0]-1][selected[1]+1] = null
                    grid[selected[0]][selected[1]] = null
                    grid[index1][index2] = "white"
                    setSelected(null)
                }
            }
        }
    }
    const makeTurn = (e) => {
        if (isPlayersTurn && ((turn === "white" && elem === "white") || (turn === "black" && elem === "black"))) {
            setSelected([index1, index2])
            console.log(selected)
        }
        else if(selected !== null && elem === null && isPlayersTurn){
            if(isTileBlack(index1, index2)) {
                if(canGo()){

                }
            }
        }
    }
    return (
        <div onClick={makeTurn}>
            <Card className={cl} >
                <CardActionArea>
                    <CardMedia
                        component="img"
                        height="140"
                        image={source}
                    />
                </CardActionArea>
            </Card>
        </div>
    );
}

export default Tile;
