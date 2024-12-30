package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAlbExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../examples",
	}
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	securityGroup := terraform.OutputRequired(t, opts, "intance_security_group_id")

	// require.NotEmpty(t, securityGroup, "Security group ID should not be empty")

	// Optionally, print the security group ID for debugging purposes
	t.Logf("Security Group ID: %s", securityGroup)
}
