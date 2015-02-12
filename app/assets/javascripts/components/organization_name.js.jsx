OrganizationName = React.createClass({
  render: function() {
    if(this.state.editing) {
      return(
          <form className="organization-name" onBlur={this.cancel} onMouseDown={this.mouseDown} onSubmit={this.save}>
          <input className="organization-name" ref="input" defaultValue={this.props.organization.name}></input>
          <input type="submit" value="Save"></input>
          <a onClick={this.cancel}>Cancel</a>
          </form>
          );
    } else {
      return(
          <h1 className="name" onClick={this.edit}>
          {this.props.organization.name}
          <span className="error">{this.errors()[0]}</span>
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
    this.setState({ mouseDown: true });
  },

  cancel: function() {
    if(this.state.mouseDown) {
      this.setState({ mouseDown: false });
    } else {
      this.setState({ editing: false });
    }
  },

  save: function(e) {
    e.preventDefault();

    var newName = this.refs.input.getDOMNode().value;
    this.setState(
        { editing: false },
        function() { this.props.onSave({ name: newName })
        });
  },

  errors: function() {
    return this.props.errors.name || [];
  },
});
