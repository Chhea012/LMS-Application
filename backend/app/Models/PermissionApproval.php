<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PermissionApproval extends Model
{
    use HasFactory;
    protected $fillable = ['permission_request_id', 'approved_by', 'comments'];

    public function request()
    {
        return $this->belongsTo(PermissionRequest::class, 'permission_request_id');
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}
