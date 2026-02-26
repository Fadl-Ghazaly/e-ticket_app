<?php

namespace App\Http\Controllers\Api;

use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request) // ✅ Tambahkan parameter Request
    {
        $products = Product::when($request->category_id, function ($query) use ($request) {
            return $query->where('category_id', $request->category_id); // ✅ Perbaiki ini
        })->get();

        $products->load('category');

        return response()->json([
            'status' => 'success',
            'data' => $products
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // ❌ SALAH: 'exists:category_id' dan 'mines' (typo)
        // ✅ BENAR: 'exists:categories,id' dan 'mimes'
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'price' => 'required|integer|min:0',
            'stok' => 'required|integer|min:0',
            'category_id' => 'required|exists:categories,id', // ✅ PERBAIKI INI
            'image' => 'nullable|image|mimes:jpg,png,jpeg,gif,svg|max:2048', // ✅ 'mimes' bukan 'mines'
            'description' => 'nullable|string',
            'status' => 'nullable|in:draft,published,archived',
            'criteria' => 'nullable|in:perorangan,rombongan',
            'favorite' => 'nullable|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->all();

        // Handle file upload
        if ($request->hasFile('image')) {
            // ❌ SALAH: 'gambar' (harusnya 'image' sesuai dengan name di form)
            // ✅ BENAR: 'image' 
            $path = $request->file('image')->store('products', 'public'); // ✅ 'image' bukan 'gambar'
            $data['image'] = $path;
        }

        $product = Product::create($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Product created successfully',
            'data' => $product->load('category')
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $product = Product::with('category')->find($id);
        
        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Product not found'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $product
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $product = Product::find($id);
        
        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Product not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|integer|min:0',
            'stok' => 'sometimes|required|integer|min:0',
            'category_id' => 'sometimes|required|exists:categories,id', // ✅ BENAR
            'image' => 'nullable|image|mimes:jpg,png,jpeg,gif,svg|max:2048',
            'description' => 'nullable|string',
            'status' => 'nullable|in:draft,published,archived',
            'criteria' => 'nullable|in:perorangan,rombongan',
            'favorite' => 'nullable|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->all();

        // Handle image update
        if ($request->hasFile('image')) {
            // Hapus gambar lama jika ada
            if ($product->image && Storage::disk('public')->exists($product->image)) {
                Storage::disk('public')->delete($product->image);
            }
            
            // Upload gambar baru
            $path = $request->file('image')->store('products', 'public');
            $data['image'] = $path;
        }

        $product->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Product updated successfully',
            'data' => $product->load('category')
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $product = Product::find($id);
        
        if (!$product) {
            return response()->json([
                'status' => 'error',
                'message' => 'Product not found'
            ], 404);
        }

        // Hapus gambar jika ada
        if ($product->image && Storage::disk('public')->exists($product->image)) {
            Storage::disk('public')->delete($product->image);
        }

        $product->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Product deleted successfully'
        ]);
    }
}