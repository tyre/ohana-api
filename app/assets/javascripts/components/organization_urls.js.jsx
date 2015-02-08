OrganizationURLs = React.createClass({
  render: function() {
    var urls = this.props.organization.urls;
    return(
        <div className="urls">
        <p><strong>URLs</strong></p>

        { this.props.organization.urls.map(this.render_url) }

        <input ref="newUrl" /><a>Add</a>
        </div>
        );
  },

  render_url: function(url, index) {
    return(
        <div className="url">
        {url}
        <a onClick={this.removeUrl(index)}>Remove</a>
        </div>
        );
  },

  removeUrl: function(index) {
    return function() {
      console.log("Removing URL #" + index);
      var urls = this.props.organization.urls;
      urls.splice(index, 1);
      this.props.onSave({urls: urls});
    }.bind(this);
  },
});
