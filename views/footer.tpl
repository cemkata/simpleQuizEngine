<%
from versionGetter import getVersion
version = getVersion('templates')
%>
% if not defined('OFFLINE'):
<script>
console.log("Quiz engine: {{version}}")
</script>
% end
<!-- templates: {{version}} -->
