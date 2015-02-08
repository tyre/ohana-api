Organization = React.createClass({
  render: function() {
    return <OrganizationName onSave={this.submit} organization={this.state} />;
  },

  getInitialState: function() {
    return this.props;
  },

  submit: function(data) {
    $.ajax({
      url: this.url(),
      dataType: 'json',
      type: 'PUT',
      data: { organization: data },
      success: function(data) {
        this.setState(data)
      }.bind(this),
      error: function(xhr, status, err) {
        alert("Error! " + err);
      }.bind(this)
    });
  },

  url: function() {
    return '/sfadmin/organizations/' + this.props.slug;
  },
});
