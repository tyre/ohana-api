OrganizationForm = React.createClass({
  render: function() {
    if(this.state.editing) {
      return(
          <form onMouseDown={this.mouseDown} onBlur={this.cancel} onSubmit={this.save}>
          <input ref="input" defaultValue={this.state.organization.name}></input>
          <input type="submit" value="Save"></input>
          <a onClick={this.cancel}>Cancel</a>
          </form>
          );
    } else {
      return(
          <h1 onClick={this.edit}>
          {this.state.organization.name}
          </h1>
          );
    }
  },

  getInitialState: function() {
    return {organization: this.props};
  },

  edit: function() {
    this.setState(
        {
          editing: true,
        },
        function() { this.refs.input.getDOMNode().focus(); }
        );
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
      organization: { name: newName },
    }, function() {
      $.ajax({
        url: this.url(),
        dataType: 'json',
        type: 'PUT',
        data: { organization: this.state.organization },
        success: function(data) {
          this.setState(data)
        }.bind(this),
        error: function(xhr, status, err) {
          alert("Error! " + err);
        }.bind(this)
      });
    });
  },

  url: function() {
    return '/sfadmin/organizations/' + this.props.slug;
  },
});
