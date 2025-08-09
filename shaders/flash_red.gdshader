shader_type canvas_item;

uniform bool flashEnabled = false;
uniform vec4 flashColor : source_color = vec4(.75, 0.0, 0.0, 1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 textureColor = texture(TEXTURE, UV);
	vec4 outputColor = textureColor;
	if (flashEnabled) {
		outputColor = mix(textureColor, flashColor, abs(textureColor.a));
	}
	COLOR = outputColor;
}
