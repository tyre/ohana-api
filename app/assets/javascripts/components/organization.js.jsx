Organization = React.createClass({
  render: function() {
    return(
        <div className="organization-inline-form">
        <OrganizationName onSave={this.submit} organization={this.state} />
        <OrganizationURLs onSave={this.submit} organization={this.state} />
        </div>
        );
  },

  getInitialState: function() {
    return this.props;
  },

  submit: function(data) {
    console.log(JSON.stringify(data));

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
