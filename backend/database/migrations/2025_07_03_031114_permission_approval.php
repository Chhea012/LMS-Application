<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('permission_approvals', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('permission_request_id');
            $table->unsignedBigInteger('approved_by');
            $table->text('comments')->nullable();
            $table->timestamps();

            $table->foreign('permission_request_id')->references('id')->on('permission_requests')->onDelete('cascade');
            $table->foreign('approved_by')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
