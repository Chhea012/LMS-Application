<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PermissionType extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'description'];

    public function accessControls()
    {
        return $this->hasMany(AccessControl::class);
    }

    public function permissionRequests()
    {
        return $this->hasMany(PermissionRequest::class);
    }
}
