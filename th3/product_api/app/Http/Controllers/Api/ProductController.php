<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Cache;

class ProductController extends Controller
{
    /**
     * Lấy danh sách tất cả sản phẩm kèm category, lưu cache 60 giây
     */
    public function index()
    {
        // Sử dụng Cache::remember để lưu cache trong 60 giây
        $products = Cache::remember('products', 60, function () {
            return Product::with('category')->get();
        });

        return response()->json($products, 200);
    }

    /**
     * Tạo một sản phẩm mới
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255', 'unique:products,name'],
            'price' => ['required', 'numeric', 'min:0'],
            'description' => ['required', 'string', 'max:500'],
            'category_id' => ['required', 'exists:categories,id'],
        ]);

        $product = Product::create($request->only(['name', 'price', 'description', 'category_id']));

        // Xóa cache cũ khi có thay đổi
        Cache::forget('products');

        $product->load('category');
        return response()->json($product, 201);
    }

    /**
     * Lấy thông tin một sản phẩm cụ thể kèm category
     */
    public function show(Product $product)
    {
        $product->load('category');
        return response()->json($product, 200);
    }

    /**
     * Cập nhật thông tin sản phẩm
     */
    public function update(Request $request, Product $product)
    {
        $request->validate([
            'name' => ['sometimes', 'string', 'max:255', Rule::unique('products', 'name')->ignore($product->id)],
            'price' => ['sometimes', 'numeric', 'min:0'],
            'description' => ['sometimes', 'string', 'max:500'],
            'category_id' => ['sometimes', 'exists:categories,id'],
        ]);

        $product->update($request->only(['name', 'price', 'description', 'category_id']));

        // Xóa cache khi có thay đổi
        Cache::forget('products');

        $product->load('category');
        return response()->json($product, 200);
    }

    /**
     * Xóa một sản phẩm
     */
    public function destroy(Product $product)
    {
        $product->delete();

        // Xóa cache khi có thay đổi
        Cache::forget('products');

        return response()->json(null, 204);
    }
}
