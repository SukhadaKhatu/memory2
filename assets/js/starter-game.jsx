import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Starter channel={channel} />, root);
}

class Starter extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    let tiles = []
    let symbols = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    
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
    
    this.channel
        .join()
        .receive("ok", this.got_view.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp); });
  }

  got_view(view) {
    console.log("new view", view);
    this.setState(view.game);
  }

  on_reset(ev) {
    this.channel.push("reset", { })
        .receive("ok", this.got_view.bind(this));
  }

  on_click(tile) {
    if(tile.active == true) {
      this.channel.push("clearstate", { }).receive("ok", this.got_view.bind(this));
      this.channel.push("moves", { }).receive("ok", this.got_view.bind(this));
      this.channel.push("prevcurrent", { tile: tile}).receive("ok", this.got_view.bind(this));
      let view = this.channel.push("checkmatch", { tile: tile}).receive("ok", this.got_view.bind(this));
      
      if(this.state.prev != null && this.state.current != null){
        if(this.state.prev.value != this.state.current.value) {
          let prev = this.state.prev;
          let current = this.state.current;
          this.timer = setTimeout(() => this.setTimer(current, tile), 1000);
        }
      }
    }
  }

    setTimer(prev, current) {
      let tiles = this.state.tiles;
      if(prev != null) {
        for(let i = 0; i < 16; i++) {
          if(tiles[i].id == prev.id) {
            tiles[i].clicked = false;
          }
        }
      }
      if(current != null) {
        for(let i = 0; i < 16; i++) {
          if(tiles[i].id == current.id) {
            tiles[i].clicked = false;
          }
        }
      }
      
      this.setState({
        prev: null,
        current: null,
        tiles: tiles
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
        let col = <div className="column" key={index} onClick={() => this.on_click(tile)}>
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
          <button onClick={this.on_reset.bind(this)}>Reset</button>
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

