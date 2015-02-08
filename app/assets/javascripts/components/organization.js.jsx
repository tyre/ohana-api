Organization = React.createClass({
  render: function() {
    return(
        <div className="organization-inline-form">
        <OrganizationName onSave={this.submit} errors={ this.state.errors } organization={this.state.organization} />
        <OrganizationURLs onSave={this.submit} errors={ this.state.errors } organization={this.state.organization} />
        </div>
        );
  },

  getInitialState: function() {
    return { errors: {}, organization: this.props };
  },

  submit: function(data) {
    $.ajax({
      url: this.url(),
      dataType: 'json',
      type: 'PUT',
      data: { organization: data },
      success: function(data) {
        this.setState({ organization: data })
      }.bind(this),
      error: function(xhr, status, err) {
        var errors = $.parseJSON(xhr.responseText);
        this.setState({ errors: errors });
      }.bind(this)
    });
  },

  url: function() {
    return '/sfadmin/organizations/' + this.props.slug;
  },
});
