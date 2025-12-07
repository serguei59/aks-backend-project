# kubectl apply vs kubectl replace

- `kubectl apply`:
  - Merges changes with the existing resource.
  - Is "declarative".
  - Preserves fields managed by other controllers.

- `kubectl replace`:
  - Deletes and recreates the resource from the given manifest.
  - Dangerous if used on core resources (you may drop fields you did not include).

For CI/CD, `apply` is almost always the right choice, combined with specific `patch` calls for dynamic fields.
