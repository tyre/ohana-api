OrganizationName = React.createClass({
  render: function() {
    if(this.state.editing) {
      return(
          <form className="organization-name" onMouseDown={this.mouseDown} onSubmit={this.save}>
          <input className="organization-name" ref="input" defaultValue={this.props.organization.name}></input>
          <input type="submit" value="Save"></input>
          <a onClick={this.cancel}>Cancel</a>
          </form>
          );
    } else {
      return(
          <h1 className="name" onClick={this.edit}>
          {this.props.organization.name}
          </h1>
          );
    }
  },

  getInitialState: function() {
    return {
      editing: false,
      mouseDown: false,
    };
  },

  edit: function() {
    this.setState({ editing: true }, function() {
      this.refs.input.getDOMNode().focus();
    });
  },

  mouseDown: function() {
    this.setState({
      mouseDown: true
    });
  },

  cancel: function() {
    if(this.state.mouseDown) {
      return this.setState({ mouseDown: false });
    };

    console.log("cancel");
    this.setState({
      editing: false,
    });
  },

  save: function(e) {
    console.log("save");
    e.preventDefault();

    var newName = this.refs.input.getDOMNode().value;
    this.setState({
      editing: false,
    }, function() {
      this.props.onSave({ name: newName });
    });
  },
});
