@extends('admin.master')

@section('title', trans('general.plugin-manage'))

@section('style')
<style>
.btn {
    margin-right: 4px;
}
td#description {
    width: 35%;
}
</style>
@endsection

@section('content')

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            {{ trans('general.plugin-manage') }}
            <small>Plugin Manage</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="box">
            <div class="box-body table-responsive no-padding">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>{{ trans('admin.plugins.name') }}</th>
                            <th>{{ trans('admin.plugins.description') }}</th>
                            <th>{{ trans('admin.plugins.author') }}</th>
                            <th>{{ trans('admin.plugins.version') }}</th>
                            <th>{{ trans('admin.plugins.status') }}</th>
                            <th>{{ trans('admin.plugins.operation') }}</th>
                        </tr>
                    </thead>

                    <tbody>
                        @forelse($installed as $plugin)
                        <tr id="plugin-{{ $plugin->name }}">
                            <td>{{ $plugin->title }}</td>
                            <td id="description">{{ $plugin->description }}</td>
                            <td id="author">{{ $plugin->author }}</td>
                            <td id="version">{{ $plugin->version }}</td>
                            <td id="status">
                                @if ($plugin->isEnabled())
                                {{ trans('admin.plugins.enabled') }}
                                @else
                                {{ trans('admin.plugins.disabled') }}
                                @endif
                            </td>

                            <td>
                                @if ($plugin->isEnabled())
                                <a class="btn btn-warning btn-sm" href="?action=disable&id={{ $plugin->name }}">{{ trans('admin.plugins.disable-plugin') }}</a>
                                @else
                                <a class="btn btn-primary btn-sm" href="?action=enable&id={{ $plugin->name }}">{{ trans('admin.plugins.enable-plugin') }}</a>
                                @endif

                                @if ($plugin->isEnabled() && $plugin->hasConfigView())
                                <a class="btn btn-default btn-sm" href="?action=config&id={{ $plugin->name }}">{{ trans('admin.plugins.plugin-config') }}</a>
                                @else
                                <a class="btn btn-default btn-sm" disabled="disabled" title="{{ trans('admin.plugins.no-config') }}" data-toggle="tooltip" data-placement="top">{{ trans('admin.plugins.no-config') }}</a>
                                @endif

                                <a class="btn btn-danger btn-sm" href="javascript:deletePlugin('{{ $plugin->name }}');">{{ trans('admin.plugins.delete-plugin') }}</a>

                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td>0</td>
                            <td>{{ trans('admin.plugins.no-result') }}</td>
                            <td>(´・ω・`)</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

@endsection

@section('style')
<style>
    @media (max-width: 767px) {
        .content-header > h1 > small {
            display: none;
        }
    }
</style>
@endsection

@section('script')
<script type="text/javascript">

function deletePlugin(name) {
    swal({
        text: trans('admin.deletionConfirmation'),
        type: 'warning',
        showCancelButton: true
    }).then(function() {
        $.ajax({
            type: "POST",
            url: "?action=delete&id=" + name,
            dataType: "json",
            success: function(json) {
                if (json.errno == 0) {
                    toastr.success(json.msg);

                    $('tr[id=plugin-'+name+']').remove();
                } else {
                    toastr.warning(json.msg);
                }
            },
            error: showAjaxError
        });
    });
}
</script>
@endsection
