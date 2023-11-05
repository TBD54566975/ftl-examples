// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const toQueryString = (params: Record<string, any>): string => {
    const searchParams = new URLSearchParams();
    Object.keys(params).forEach(key => {
      const value = params[key];
      if (Array.isArray(value)) {
        value.forEach((item) => searchParams.append(key, item));
      } else {
        searchParams.append(key, value);
      }
    });
    return searchParams.toString();
  }
  