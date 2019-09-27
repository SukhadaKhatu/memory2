import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root) {
  ReactDOM.render(<Starter />, root);
}

class Starter extends React.Component {
  constructor(props) {
    super(props);
    let tiles = []
    let symbols = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    symbols.sort(() => 0.5 - Math.random());
    let id = 1;
    for(let i = 0; i < 16; i++) {
      tiles.push({id: id, clicked: false, value: symbols[i], active: true});
      id++;
    }
    this.state = { 
      tiles: tiles,
      prev: null,
      current: null,
      moves: 0,
  };
  }

  reset() {
   let symbols = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
   let tiles = []
   symbols.sort(() => 0.5 - Math.random());
   let id = 1;
   for(let i = 0; i < 16; i++) {
     tiles.push({id: id, clicked: false, value: symbols[i], active: true});
     id++;
   }
   this.setState({tiles: tiles,
    prev: null,
    current: null,
    moves: 0});
  }

  checkValue(tile) {
    if(tile.active == true) {
      let prev = this.state.prev;
      let current = this.state.current;
      let moves = this.state.moves;
      moves++;
      if(prev != null) {
        prev.clicked = false;
      }
      prev = current;
      current = tile;
      if(prev != null && current != null) {
        if(prev.value == current.value) {
          console.log("Match found")
          prev.active = false;
          current.active = false;
          current = null;
          prev = null;
          this.setState({prev: prev,
          current: current,
          moves: moves});
        }else {
          console.log("No match")
          prev.clicked = true;
          current.clicked = true;
          this.setState({prev: prev, current: current, moves: moves});         
          this.timer = setTimeout(() => this.setTimer(prev, current), 1000);
        }
      }else {
        console.log("null")
        if(prev != null) {
          prev.clicked = true;
        } 
        if(current != null) {
          current.clicked = true;
        }
        this.setState({prev: prev, current: current, moves: moves});
      }
      console.log(prev)
      console.log(current)
      console.log(this.state.tiles)
      }
    }

    setTimer(prev, current) {
      if(prev != null) {
        prev.clicked = false;
      }
      if(current != null) {
        current.clicked = false;
      }
      current = null;
      prev = null;
      this.setState({
        prev: prev,
        current: current
      });
      clearTimeout(this.timer);
    }
  
  
  render() {
    let rows = [];
    let tiles = this.state.tiles;
    let index = 0;
    for (let ii = 0; ii < 4; ++ii) {
      let cols = [];
      for (let jj = 0; jj < 4; ++jj) {
        let tile = tiles[index];
        let col = <div className="column" key={index} onClick={() => this.checkValue(tile)}>
          <Tile key={index} tile={tile}/>
        </div>;
        index++;
        cols.push(col);
      }
      rows.push(
        <div className="row">
          {cols}
        </div>
      );
    }

    return(
      <div>
        <div>
        <div>
          <p>Moves: {this.state.moves}</p>
        </div>
        <div>
          <button onClick={() => this.reset()}>Reset</button>
        </div>
        </div>
        {rows}
      </div>
    );
  }
}

function Tile(props) {
  let {tile} = props;
  let tileValue = tile.value;
  if(tile.clicked == true || tile.active == false) {
    return (
      <div className={"tile" + (tile.active ? 'hidden':'show')}>
        <p>{tileValue}</p>
      </div>
    );
  } else {
    return (
      <div>
        <p></p>
      </div>
    );
  }
}

